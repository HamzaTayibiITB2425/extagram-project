# Alertas de Grafana a Telegram

## Configuración

### 1. Crear Bot de Telegram

1. Abre Telegram y busca **@BotFather**
2. Envia `/newbot`
3. Segueix les instruccions per crear el bot
4. Guarda el **token** que te donen

### 2. Obtener Chat ID

1. Envia un missatge al teu bot
2. Obre al navegador:
```
   https://api.telegram.org/bot<TU_TOKEN>/getUpdates
```
3. Busca el camp `"chat":{"id":123456789}` 
4. Guarda aquest **chat_id**

### 3. Configurar Alertas
```bash
cd ~/extagram-project/configuracions/docker

# Copiar archivo de ejemplo
cp alertas.env.example alertas.env

# Editar con tus credenciales
nano alertas.env
```

**Contenido de alertas.env:**
```bash
TELEGRAM_BOT_TOKEN=tu_token_aqui
TELEGRAM_CHAT_ID=tu_chat_id_aqui
GRAFANA_USER=admin
GRAFANA_PASS=password
GRAFANA_URL=http://localhost:3000/grafana
```

### 4. Ejecutar Configuración
```bash
./configure-grafana-alerts-template.sh
```

## Alertas Configuradas

### 1. CPU Alta (Warning)

**Condición:** CPU > 80% durant 2 minuts  
**Query PromQL:**
```promql
rate(container_cpu_usage_seconds_total{name=~"extagram.*"}[1m]) * 100 > 80
```

**Missatge Telegram:**
```
⚠️ ALERTA EXTAGRAM

Estado: Firing
Servicio: extagram-s2-php
Descripción: CPU superior al 80%
Detalles: El contenedor extagram-s2-php está usando 85.3% de CPU
```

### 2. Memoria Alta (Warning)

**Condició:** Memòria > 1GB durant 3 minuts  
**Query:**
```promql
container_memory_usage_bytes{name=~"extagram.*"} / 1024 / 1024 > 1024
```

### 3. Contenedor Caído (Critical)

**Condició:** Menys de 13 contenidors actius durant 1 minut  
**Query:**
```promql
count(container_last_seen{name=~"extagram.*"}) < 13
```

### 4. Disco I/O Alto (Warning)

**Condició:** Escriptura > 10MB/s durant 5 minuts  
**Query:**
```promql
rate(container_fs_writes_bytes_total{name=~"extagram.*"}[1m]) > 10485760
```

### 5. Network Traffic Alto (Info)

**Condició:** Transmissió > 20MB/s durant 3 minuts  
**Query:**
```promql
rate(container_network_transmit_bytes_total{name=~"extagram.*"}[1m]) > 20971520
```

## Provar Alertes

### Test 1: CPU Alta
```bash
./test-alert-cpu.sh
```

### Test 2: Contenedor Caído
```bash
docker stop extagram-s3-php
# Esperar 2 minuts
docker start extagram-s3-php
```

### Test 3: Tràfic de Xarxa
```bash
ab -n 10000 -c 100 https://extagram-grup3.duckdns.org/extagram.php
```

## Gestió d'Alertes

### Veure Alertes Actives

https://extagram-grup3.duckdns.org/grafana/alerting/list

### Silenciar Alerta

1. Alerting → Alert rules
2. Clic a l'alerta
3. Silence → Create silence
4. Durada: 1h / 4h / 1d
5. Comment: "Manteniment programat"

### Modificar Llindars

Editar `configure-grafana-alerts-template.sh`:
```bash
# Canviar llindar CPU de 80% a 90%
"expr": "rate(...) * 100 > 90",
```

Reexecutar:
```bash
./configure-grafana-alerts-template.sh
```

## Troubleshooting

### No Rebo Alertes

**1. Verificar Contact Point:**
```bash
curl -u admin:password http://localhost:3000/grafana/api/v1/provisioning/contact-points | jq
```

**2. Test manual a Grafana:**

Alerting → Contact points → Telegram Extagram → Test

**3. Verificar bot:**
```bash
curl "https://api.telegram.org/bot<TOKEN>/getMe"
```

### Alerta No Es Dispara

**1. Verificar query a Grafana Explore**

**2. Veure logs:**
```bash
docker logs extagram-grafana --tail 100 | grep -i alert
```

**3. Verificar estat:**

Grafana → Alerting → Alert rules → [Alerta]

## Seguretat

**IMPORTANT:** L'arxiu `alertas.env` conté credencials i **NO s'ha de pujar a GitHub**.

Està inclòs a `.gitignore`:
```
alertas.env
configure-grafana-alerts.sh
```

Només es puja `alertas.env.example` amb placeholders.

---

**Document elaborat per:** Hamza  
**Data:** 10 de Març de 2026  
**Versió:** 1.0
