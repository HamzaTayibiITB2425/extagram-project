#!/bin/bash

echo "================================================"
echo "PROBANDO ALERTA DE CPU ALTA"
echo "================================================"
echo ""
echo "Generando carga de CPU en S2..."
docker exec extagram-s2-php sh -c 'yes > /dev/null &'
echo "✓ Proceso iniciado"
echo ""
echo "Esperando 150 segundos (2.5 min) para que se dispare la alerta..."
sleep 150
echo ""
echo "Deteniendo carga de CPU..."
docker exec extagram-s2-php sh -c 'killall yes' 2>/dev/null
echo "✓ Proceso detenido"
echo ""
echo "Deberías recibir una alerta en Telegram en 1-2 minutos."
echo "Si no la recibes, verifica:"
echo "  1. Grafana → Alerting → Alert rules"
echo "  2. Logs: docker logs extagram-grafana --tail 100"
echo ""
