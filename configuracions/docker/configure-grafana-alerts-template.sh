#!/bin/bash

echo "================================================"
echo "CONFIGURANDO ALERTAS GRAFANA → TELEGRAM"
echo "================================================"
echo ""

# Verificar que existe el archivo de configuración
if [ ! -f "alertas.env" ]; then
    echo "❌ ERROR: No se encuentra alertas.env"
    echo ""
    echo "Por favor crea el archivo alertas.env con tus credenciales:"
    echo "  cp alertas.env.example alertas.env"
    echo "  nano alertas.env"
    echo ""
    exit 1
fi

# Cargar variables de entorno
source alertas.env

# Verificar que las variables están configuradas
if [ -z "$TELEGRAM_BOT_TOKEN" ] || [ "$TELEGRAM_BOT_TOKEN" == "your_telegram_bot_token_here" ]; then
    echo "❌ ERROR: TELEGRAM_BOT_TOKEN no está configurado"
    echo "Edita alertas.env y configura tu token de bot"
    exit 1
fi

if [ -z "$TELEGRAM_CHAT_ID" ] || [ "$TELEGRAM_CHAT_ID" == "your_telegram_chat_id_here" ]; then
    echo "❌ ERROR: TELEGRAM_CHAT_ID no está configurado"
    echo "Edita alertas.env y configura tu chat ID"
    exit 1
fi

# Esperar a que Grafana esté listo
echo "Esperando a que Grafana esté disponible..."
until curl -s ${GRAFANA_URL}/api/health > /dev/null 2>&1; do
    sleep 2
done
echo "✓ Grafana disponible"
echo ""

# ============================================
# 1. CREAR CONTACT POINT TELEGRAM
# ============================================
echo "1. Creando Contact Point Telegram..."

curl -X POST \
  -H "Content-Type: application/json" \
  -u ${GRAFANA_USER}:${GRAFANA_PASS} \
  ${GRAFANA_URL}/api/v1/provisioning/contact-points \
  -d '{
    "name": "Telegram Extagram",
    "type": "telegram",
    "settings": {
      "bottoken": "'${TELEGRAM_BOT_TOKEN}'",
      "chatid": "'${TELEGRAM_CHAT_ID}'",
      "message": "⚠️ ALERTA EXTAGRAM\n\n{{ range .Alerts }}\n*Estado:* {{ .Status }}\n*Servicio:* {{ .Labels.container_name }}\n*Descripción:* {{ .Annotations.summary }}\n*Detalles:* {{ .Annotations.description }}\n{{ end }}"
    },
    "disableResolveMessage": false
  }' 2>/dev/null

echo "✓ Contact Point Telegram creado"
echo ""

# ============================================
# 2. ACTUALIZAR NOTIFICATION POLICY
# ============================================
echo "2. Configurando Notification Policy..."

curl -X PUT \
  -H "Content-Type: application/json" \
  -u ${GRAFANA_USER}:${GRAFANA_PASS} \
  ${GRAFANA_URL}/api/v1/provisioning/policies \
  -d '{
    "receiver": "Telegram Extagram",
    "group_by": ["alertname", "grafana_folder", "container_name"],
    "group_wait": "10s",
    "group_interval": "5m",
    "repeat_interval": "12h"
  }' 2>/dev/null

echo "✓ Notification Policy configurado"
echo ""

# ============================================
# 3. OBTENER UID DEL DATASOURCE PROMETHEUS
# ============================================
echo "3. Obteniendo UID de Prometheus..."

PROM_UID=$(curl -s -u ${GRAFANA_USER}:${GRAFANA_PASS} \
  ${GRAFANA_URL}/api/datasources | \
  jq -r '.[] | select(.type=="prometheus") | .uid')

if [ -z "$PROM_UID" ]; then
    echo "❌ ERROR: No se pudo obtener UID de Prometheus"
    exit 1
fi

echo "✓ Prometheus UID: ${PROM_UID}"
echo ""

# ============================================
# 4. CREAR ALERTA: CPU ALTA
# ============================================
echo "4. Creando alerta: CPU Alta (>80%)..."

curl -X POST \
  -H "Content-Type: application/json" \
  -u ${GRAFANA_USER}:${GRAFANA_PASS} \
  ${GRAFANA_URL}/api/v1/provisioning/alert-rules \
  -d '{
    "uid": "cpu-alta-extagram",
    "title": "CPU Alta en Contenedor",
    "condition": "A",
    "data": [
      {
        "refId": "A",
        "queryType": "",
        "relativeTimeRange": {
          "from": 600,
          "to": 0
        },
        "datasourceUid": "'${PROM_UID}'",
        "model": {
          "expr": "rate(container_cpu_usage_seconds_total{name=~\"extagram.*\"}[1m]) * 100 > 80",
          "intervalMs": 1000,
          "maxDataPoints": 43200,
          "refId": "A"
        }
      }
    ],
    "noDataState": "NoData",
    "execErrState": "Error",
    "for": "2m",
    "annotations": {
      "summary": "CPU superior al 80%",
      "description": "El contenedor {{ $labels.name }} está usando {{ $value }}% de CPU"
    },
    "labels": {
      "severity": "warning",
      "team": "extagram"
    },
    "folderUID": "general"
  }' 2>/dev/null

echo "✓ Alerta CPU creada"
echo ""

# ============================================
# 5. CREAR ALERTA: MEMORIA ALTA
# ============================================
echo "5. Creando alerta: Memoria Alta (>1GB)..."

curl -X POST \
  -H "Content-Type: application/json" \
  -u ${GRAFANA_USER}:${GRAFANA_PASS} \
  ${GRAFANA_URL}/api/v1/provisioning/alert-rules \
  -d '{
    "uid": "memoria-alta-extagram",
    "title": "Memoria Alta en Contenedor",
    "condition": "A",
    "data": [
      {
        "refId": "A",
        "queryType": "",
        "relativeTimeRange": {
          "from": 600,
          "to": 0
        },
        "datasourceUid": "'${PROM_UID}'",
        "model": {
          "expr": "container_memory_usage_bytes{name=~\"extagram.*\"} / 1024 / 1024 > 1024",
          "intervalMs": 1000,
          "maxDataPoints": 43200,
          "refId": "A"
        }
      }
    ],
    "noDataState": "NoData",
    "execErrState": "Error",
    "for": "3m",
    "annotations": {
      "summary": "Memoria superior a 1GB",
      "description": "El contenedor {{ $labels.name }} está usando {{ $value }}MB de RAM"
    },
    "labels": {
      "severity": "warning",
      "team": "extagram"
    },
    "folderUID": "general"
  }' 2>/dev/null

echo "✓ Alerta Memoria creada"
echo ""

# ============================================
# 6. CREAR ALERTA: CONTENEDOR CAÍDO
# ============================================
echo "6. Creando alerta: Contenedor Caído..."

curl -X POST \
  -H "Content-Type: application/json" \
  -u ${GRAFANA_USER}:${GRAFANA_PASS} \
  ${GRAFANA_URL}/api/v1/provisioning/alert-rules \
  -d '{
    "uid": "contenedor-caido-extagram",
    "title": "Contenedor Caído",
    "condition": "A",
    "data": [
      {
        "refId": "A",
        "queryType": "",
        "relativeTimeRange": {
          "from": 600,
          "to": 0
        },
        "datasourceUid": "'${PROM_UID}'",
        "model": {
          "expr": "count(container_last_seen{name=~\"extagram.*\"}) < 13",
          "intervalMs": 1000,
          "maxDataPoints": 43200,
          "refId": "A"
        }
      }
    ],
    "noDataState": "Alerting",
    "execErrState": "Error",
    "for": "1m",
    "annotations": {
      "summary": "Contenedor caído detectado",
      "description": "Hay menos de 13 contenedores Extagram corriendo. Actualmente: {{ $value }}"
    },
    "labels": {
      "severity": "critical",
      "team": "extagram"
    },
    "folderUID": "general"
  }' 2>/dev/null

echo "✓ Alerta Contenedor Caído creada"
echo ""

# ============================================
# 7. CREAR ALERTA: DISCO I/O ALTO
# ============================================
echo "7. Creando alerta: Disco I/O Alto..."

curl -X POST \
  -H "Content-Type: application/json" \
  -u ${GRAFANA_USER}:${GRAFANA_PASS} \
  ${GRAFANA_URL}/api/v1/provisioning/alert-rules \
  -d '{
    "uid": "disco-io-alto-extagram",
    "title": "Disco I/O Alto",
    "condition": "A",
    "data": [
      {
        "refId": "A",
        "queryType": "",
        "relativeTimeRange": {
          "from": 600,
          "to": 0
        },
        "datasourceUid": "'${PROM_UID}'",
        "model": {
          "expr": "rate(container_fs_writes_bytes_total{name=~\"extagram.*\"}[1m]) > 10485760",
          "intervalMs": 1000,
          "maxDataPoints": 43200,
          "refId": "A"
        }
      }
    ],
    "noDataState": "NoData",
    "execErrState": "Error",
    "for": "5m",
    "annotations": {
      "summary": "Disco I/O superior a 10MB/s",
      "description": "El contenedor {{ $labels.name }} está escribiendo {{ $value | humanize }}B/s al disco"
    },
    "labels": {
      "severity": "warning",
      "team": "extagram"
    },
    "folderUID": "general"
  }' 2>/dev/null

echo "✓ Alerta Disco I/O creada"
echo ""

# ============================================
# 8. CREAR ALERTA: NETWORK TRAFFIC ALTO
# ============================================
echo "8. Creando alerta: Network Traffic Alto..."

curl -X POST \
  -H "Content-Type: application/json" \
  -u ${GRAFANA_USER}:${GRAFANA_PASS} \
  ${GRAFANA_URL}/api/v1/provisioning/alert-rules \
  -d '{
    "uid": "network-alto-extagram",
    "title": "Network Traffic Alto",
    "condition": "A",
    "data": [
      {
        "refId": "A",
        "queryType": "",
        "relativeTimeRange": {
          "from": 600,
          "to": 0
        },
        "datasourceUid": "'${PROM_UID}'",
        "model": {
          "expr": "rate(container_network_transmit_bytes_total{name=~\"extagram.*\"}[1m]) > 20971520",
          "intervalMs": 1000,
          "maxDataPoints": 43200,
          "refId": "A"
        }
      }
    ],
    "noDataState": "NoData",
    "execErrState": "Error",
    "for": "3m",
    "annotations": {
      "summary": "Tráfico de red superior a 20MB/s",
      "description": "El contenedor {{ $labels.name }} está transmitiendo {{ $value | humanize }}B/s"
    },
    "labels": {
      "severity": "info",
      "team": "extagram"
    },
    "folderUID": "general"
  }' 2>/dev/null

echo "✓ Alerta Network Traffic creada"
echo ""

echo "================================================"
echo "✓ CONFIGURACIÓN COMPLETADA"
echo "================================================"
echo ""
echo "Alertas configuradas:"
echo "  1. CPU Alta (>80%) → Warning"
echo "  2. Memoria Alta (>1GB) → Warning"
echo "  3. Contenedor Caído (<13) → Critical"
echo "  4. Disco I/O Alto (>10MB/s) → Warning"
echo "  5. Network Traffic Alto (>20MB/s) → Info"
echo ""
echo "Contact Point: Telegram Extagram"
echo "Chat ID: ${TELEGRAM_CHAT_ID}"
echo ""
echo "Verifica en Grafana:"
echo "  https://extagram-grup3.duckdns.org/grafana/alerting/list"
echo ""
