#!/bin/bash

# Esperar a que Grafana esté listo
until curl -s http://localhost:3000/grafana/api/health > /dev/null 2>&1; do
    echo "Esperando Grafana..."
    sleep 2
done

# Obtener UIDs reales
LOKI_UID=$(curl -s -u admin:admin123 http://localhost:3000/grafana/api/datasources | jq -r '.[] | select(.type=="loki") | .uid')
PROM_UID=$(curl -s -u admin:admin123 http://localhost:3000/grafana/api/datasources | jq -r '.[] | select(.type=="prometheus") | .uid')

# Crear datasource Prometheus si no existe
curl -s -X POST -H "Content-Type: application/json" \
  -u admin:admin123 \
  http://localhost:3000/grafana/api/datasources \
  -d '{
    "name": "Prometheus",
    "type": "prometheus",
    "url": "http://prometheus:9090",
    "access": "proxy",
    "isDefault": true
  }' > /dev/null 2>&1

# Crear datasource Loki si no existe
curl -s -X POST -H "Content-Type: application/json" \
  -u admin:admin123 \
  http://localhost:3000/grafana/api/datasources \
  -d '{
    "name": "Loki",
    "type": "loki",
    "url": "http://loki:3100",
    "access": "proxy"
  }' > /dev/null 2>&1

# Obtener UIDs actualizados después de crear
LOKI_UID=$(curl -s -u admin:admin123 http://localhost:3000/grafana/api/datasources | jq -r '.[] | select(.type=="loki") | .uid')
PROM_UID=$(curl -s -u admin:admin123 http://localhost:3000/grafana/api/datasources | jq -r '.[] | select(.type=="prometheus") | .uid')

# Crear dashboard con UIDs correctos
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

# Configurar dashboard como home
curl -s -X PUT -H "Content-Type: application/json" \
  -u admin:admin123 \
  http://localhost:3000/grafana/api/org/preferences \
  -d '{"homeDashboardUID":"extagram-main","theme":"dark"}' > /dev/null

echo "Grafana inicializado correctamente"
