#!/bin/bash

cd ~/extagram-project/configuracions/docker

echo "=== FIX COMPLETO DE MONITORING ==="

# 1. REINICIAR CADVISOR
echo "1. Reiniciando cAdvisor..."
docker compose restart cadvisor
sleep 10

# 2. VERIFICAR QUE CADVISOR RESPONDE
echo "2. Verificando cAdvisor..."
if curl -s http://localhost:8080/metrics | grep -q container_cpu; then
    echo "   ✅ cAdvisor funciona"
else
    echo "   ❌ cAdvisor no responde - reiniciando..."
    docker compose stop cadvisor
    docker compose up -d cadvisor
    sleep 15
fi

# 3. OBTENER UIDs REALES
echo "3. Obteniendo UIDs de datasources..."
LOKI_UID=$(curl -s -u admin:admin123 http://localhost:3000/grafana/api/datasources | jq -r '.[] | select(.type=="loki") | .uid')
PROM_UID=$(curl -s -u admin:admin123 http://localhost:3000/grafana/api/datasources | jq -r '.[] | select(.type=="prometheus") | .uid')

echo "   Loki UID: $LOKI_UID"
echo "   Prometheus UID: $PROM_UID"

# 4. ACTUALIZAR DASHBOARD CON UIDs CORRECTOS
echo "4. Actualizando dashboard..."
curl -s -X POST -H "Content-Type: application/json" \
  -u admin:admin123 \
  http://localhost:3000/grafana/api/dashboards/db \
  -d "{
  \"dashboard\": {
    \"id\": null,
    \"uid\": \"extagram-main\",
    \"title\": \"Extagram Docker Monitoring\",
    \"tags\": [\"docker\", \"monitoring\"],
    \"timezone\": \"browser\",
    \"schemaVersion\": 16,
    \"version\": 0,
    \"refresh\": \"5s\",
    \"panels\": [
      {
        \"id\": 1,
        \"gridPos\": {\"h\": 8, \"w\": 12, \"x\": 0, \"y\": 0},
        \"type\": \"timeseries\",
        \"title\": \"CPU Usage por Contenedor\",
        \"targets\": [
          {
            \"expr\": \"rate(container_cpu_usage_seconds_total{name=~\\\"extagram.*\\\"}[30s]) * 100\",
            \"legendFormat\": \"{{name}}\",
            \"refId\": \"A\",
            \"datasource\": {\"type\": \"prometheus\", \"uid\": \"$PROM_UID\"}
          }
        ],
        \"fieldConfig\": {
          \"defaults\": {
            \"unit\": \"percent\",
            \"custom\": {\"drawStyle\": \"line\", \"fillOpacity\": 10}
          }
        }
      },
      {
        \"id\": 2,
        \"gridPos\": {\"h\": 8, \"w\": 12, \"x\": 12, \"y\": 0},
        \"type\": \"timeseries\",
        \"title\": \"Memoria Usage por Contenedor\",
        \"targets\": [
          {
            \"expr\": \"container_memory_usage_bytes{name=~\\\"extagram.*\\\"} / 1024 / 1024\",
            \"legendFormat\": \"{{name}}\",
            \"refId\": \"A\",
            \"datasource\": {\"type\": \"prometheus\", \"uid\": \"$PROM_UID\"}
          }
        ],
        \"fieldConfig\": {
          \"defaults\": {
            \"unit\": \"mbytes\",
            \"custom\": {\"drawStyle\": \"line\", \"fillOpacity\": 10}
          }
        }
      },
      {
        \"id\": 3,
        \"gridPos\": {\"h\": 8, \"w\": 12, \"x\": 0, \"y\": 8},
        \"type\": \"timeseries\",
        \"title\": \"Network I/O por Contenedor\",
        \"targets\": [
          {
            \"expr\": \"rate(container_network_receive_bytes_total{name=~\\\"extagram.*\\\"}[30s])\",
            \"legendFormat\": \"{{name}} RX\",
            \"refId\": \"A\",
            \"datasource\": {\"type\": \"prometheus\", \"uid\": \"$PROM_UID\"}
          },
          {
            \"expr\": \"rate(container_network_transmit_bytes_total{name=~\\\"extagram.*\\\"}[30s])\",
            \"legendFormat\": \"{{name}} TX\",
            \"refId\": \"B\",
            \"datasource\": {\"type\": \"prometheus\", \"uid\": \"$PROM_UID\"}
          }
        ],
        \"fieldConfig\": {
          \"defaults\": {
            \"unit\": \"Bps\",
            \"custom\": {\"drawStyle\": \"line\", \"fillOpacity\": 10}
          }
        }
      },
      {
        \"id\": 4,
        \"gridPos\": {\"h\": 8, \"w\": 12, \"x\": 12, \"y\": 8},
        \"type\": \"stat\",
        \"title\": \"Contenedores Running\",
        \"targets\": [
          {
            \"expr\": \"count(container_last_seen{name=~\\\"extagram.*\\\"})\",
            \"refId\": \"A\",
            \"datasource\": {\"type\": \"prometheus\", \"uid\": \"$PROM_UID\"}
          }
        ],
        \"options\": {
          \"graphMode\": \"none\",
          \"colorMode\": \"value\",
          \"textMode\": \"value_and_name\"
        }
      },
      {
        \"id\": 6,
        \"gridPos\": {\"h\": 10, \"w\": 24, \"x\": 0, \"y\": 16},
        \"type\": \"logs\",
        \"title\": \"Container Logs\",
        \"targets\": [
          {
            \"expr\": \"{job=\\\"docker\\\"}\",
            \"refId\": \"A\",
            \"datasource\": {\"type\": \"loki\", \"uid\": \"$LOKI_UID\"}
          }
        ],
        \"options\": {
          \"showTime\": true,
          \"showLabels\": true,
          \"wrapLogMessage\": true,
          \"sortOrder\": \"Descending\"
        }
      }
    ]
  },
  \"overwrite\": true
}" > /dev/null

echo "   ✅ Dashboard actualizado"

# 5. VERIFICAR MÉTRICAS
echo "5. Verificando métricas..."
METRICS_COUNT=$(curl -s http://localhost:8080/metrics | grep -c "container_cpu_usage_seconds_total{name=\"extagram")
echo "   Métricas de contenedores Extagram: $METRICS_COUNT"

echo ""
echo "=========================================="
echo "✅ FIX COMPLETADO"
echo "=========================================="
echo ""
echo "Espera 30 segundos y recarga Grafana:"
echo "https://extagram-grup3.duckdns.org/grafana/d/extagram-main/"
