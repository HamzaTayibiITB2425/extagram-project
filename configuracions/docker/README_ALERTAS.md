# Configuración de Alertas Telegram

## Instalación Rápida
```bash
# 1. Copiar archivo de ejemplo
cp alertas.env.example alertas.env

# 2. Editar con tus credenciales
nano alertas.env

# 3. Configurar alertas
./configure-grafana-alerts-template.sh

# 4. Probar
./test-alert-cpu.sh
```

## Archivos

- `alertas.env.example` - Plantilla (SÍ subir a GitHub)
- `alertas.env` - Credenciales reales (NO subir a GitHub)
- `configure-grafana-alerts-template.sh` - Script configuración (SÍ subir)
- `test-alert-cpu.sh` - Script de prueba (SÍ subir)

## Documentación Completa

Ver: [docs/ALERTAS_TELEGRAM.md](../../docs/ALERTAS_TELEGRAM.md)
