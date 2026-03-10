# Configuració Monitoring - Grafana + Loki + Prometheus

## Índex

1. [Introducció](#introducció)
2. [Arquitectura de Monitoratge](#arquitectura-de-monitoratge)
3. [Instal·lació de Components](#installació-de-components)
   - [Grafana](#grafana)
   - [Loki](#loki)
   - [Promtail](#promtail)
   - [Prometheus](#prometheus)
   - [cAdvisor](#cadvisor)
4. [Configuració Detallada](#configuració-detallada)
5. [Crear Dashboard](#crear-dashboard)
6. [Auto-inicialització](#auto-inicialització)
7. [Queries Útils](#queries-útils)
8. [Troubleshooting](#troubleshooting)

---

## Introducció

Aquest document proporciona una guia completa pas a pas per configurar el sistema de monitoratge centralitzat d'Extagram amb **Grafana**, **Loki**, **Prometheus**, **Promtail** i **cAdvisor**.

**Objectiu:** Sistema de monitoratge unificat que centralitzi logs i mètriques de tots els contenidors.

---

## Arquitectura de Monitoratge
```
Docker Containers (S1-S8)
       ↓
   Promtail (Logs) ────────→ Loki (Storage) ────────┐
       ↓                                             ↓
   cAdvisor (Mètriques) ───→ Prometheus (Storage) ──→ Grafana (Visualització)
                                                      ↑
                                              Dashboards + Queries
```

### Flux de Dades

**Logs:**
1. Docker genera logs → stdout/stderr
2. Promtail detecta contenidors (docker_sd_configs)
3. Promtail extreu etiqueta `container_name`
4. Promtail envia logs a Loki
5. Loki indexa i emmagatzema
6. Grafana consulta Loki (LogQL)

**Mètriques:**
1. Contenidors executen processos
2. cAdvisor recopila mètriques (CPU, RAM, xarxa, disc)
3. cAdvisor exposa mètriques a `/cadvisor/metrics`
4. Prometheus scrape cada 5 segons
5. Prometheus emmagatzema sèries temporals
6. Grafana consulta Prometheus (PromQL)

---

## Instal·lació de Components

### Grafana

**Docker Compose:**
```yaml
grafana:
  image: grafana/grafana:latest
  container_name: extagram-grafana
  restart: unless-stopped
  ports:
    - "3000:3000"
  environment:
    - GF_SECURITY_ADMIN_USER=admin
    - GF_SECURITY_ADMIN_PASSWORD=admin123
    - GF_SERVER_DOMAIN=extagram-grup3.duckdns.org
    - GF_SERVER_ROOT_URL=https://extagram-grup3.duckdns.org/grafana/
    - GF_SERVER_SERVE_FROM_SUB_PATH=true
  volumes:
    - grafana-data:/var/lib/grafana
  networks:
    - monitoring
  depends_on:
    - loki
    - prometheus
```

**Accés:** https://extagram-grup3.duckdns.org/grafana/  
**Credencials:** admin / admin123

### Loki

**Docker Compose:**
```yaml
loki:
  image: grafana/loki:latest
  container_name: extagram-loki
  restart: unless-stopped
  ports:
    - "3100:3100"
  volumes:
    - ./monitoring/loki/loki-config.yml:/etc/loki/local-config.yaml
  command: -config.file=/etc/loki/local-config.yaml
  networks:
    - monitoring
```

**Configuració:** `monitoring/loki/loki-config.yml`
```yaml
auth_enabled: false

server:
  http_listen_port: 3100

ingester:
  lifecycler:
    ring:
      kvstore:
        store: inmemory
      replication_factor: 1
  chunk_idle_period: 5m
  chunk_retain_period: 30s

schema_config:
  configs:
    - from: 2025-01-01
      store: boltdb
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 24h

storage_config:
  boltdb:
    directory: /loki/index
  filesystem:
    directory: /loki/chunks

limits_config:
  enforce_metric_name: false
  reject_old_samples: true
  reject_old_samples_max_age: 168h  # 7 dies
  ingestion_rate_mb: 10
  ingestion_burst_size_mb: 20
```

### Promtail

**Docker Compose:**
```yaml
promtail:
  image: grafana/promtail:latest
  container_name: extagram-promtail
  restart: unless-stopped
  volumes:
    - ./monitoring/promtail/promtail-config.yml:/etc/promtail/config.yml
    - /var/run/docker.sock:/var/run/docker.sock
  command: -config.file=/etc/promtail/config.yml
  networks:
    - monitoring
  depends_on:
    - loki
```

**Configuració:** `monitoring/promtail/promtail-config.yml`
```yaml
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://loki:3100/loki/api/v1/push

scrape_configs:
  - job_name: docker
    docker_sd_configs:
      - host: unix:///var/run/docker.sock
        refresh_interval: 5s
    
    relabel_configs:
      - source_labels: ['__meta_docker_container_name']
        regex: '/(.*)'
        target_label: 'container_name'
      
      - source_labels: ['__meta_docker_container_log_stream']
        target_label: 'stream'
    
    pipeline_stages:
      - docker: {}
```

**Clau:** `docker_sd_configs` - Detecció automàtica de contenidors

### Prometheus

**Docker Compose:**
```yaml
prometheus:
  image: prom/prometheus:latest
  container_name: extagram-prometheus
  restart: unless-stopped
  ports:
    - "9090:9090"
  volumes:
    - ./monitoring/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
    - prometheus-data:/prometheus
  command:
    - '--config.file=/etc/prometheus/prometheus.yml'
    - '--storage.tsdb.path=/prometheus'
    - '--web.console.libraries=/usr/share/prometheus/console_libraries'
    - '--web.console.templates=/usr/share/prometheus/consoles'
  networks:
    - monitoring
```

**Configuració:** `monitoring/prometheus/prometheus.yml`
```yaml
global:
  scrape_interval: 5s
  evaluation_interval: 5s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
  
  - job_name: 'cadvisor'
    metrics_path: '/cadvisor/metrics'
    static_configs:
      - targets: ['cadvisor:8080']
```

**Clau:** `metrics_path: '/cadvisor/metrics'` - Ruta correcta

### cAdvisor

**Docker Compose:**
```yaml
cadvisor:
  image: gcr.io/cadvisor/cadvisor:latest
  container_name: extagram-cadvisor
  restart: unless-stopped
  ports:
    - "8080:8080"
  volumes:
    - /:/rootfs:ro
    - /var/run:/var/run:ro
    - /sys:/sys:ro
    - /var/lib/docker/:/var/lib/docker:ro
    - /dev/disk/:/dev/disk:ro
  privileged: true
  command:
    - '--url_base_prefix=/cadvisor'
  networks:
    - monitoring
```

**Clau:** `--url_base_prefix=/cadvisor` - Permet accés via subpath

---

## Configuració Detallada

### 1. Crear Xarxa Docker
```bash
docker network create monitoring
```

### 2. Crear Directoris de Configuració
```bash
cd ~/extagram-project/configuracions/docker

mkdir -p monitoring/loki
mkdir -p monitoring/promtail
mkdir -p monitoring/prometheus
```

### 3. Crear Arxius de Configuració

**Loki:**
```bash
cat > monitoring/loki/loki-config.yml << 'EOF'
[... contingut loki-config.yml ...]
EOF
```

**Promtail:**
```bash
cat > monitoring/promtail/promtail-config.yml << 'EOF'
[... contingut promtail-config.yml ...]
EOF
```

**Prometheus:**
```bash
cat > monitoring/prometheus/prometheus.yml << 'EOF'
[... contingut prometheus.yml ...]
EOF
```

### 4. Iniciar Serveis
```bash
docker compose up -d grafana loki promtail prometheus cadvisor
```

### 5. Verificar Serveis
```bash
docker ps | grep -E "(grafana|loki|promtail|prometheus|cadvisor)"
```

**Sortida esperada:**
```
extagram-grafana       Up
extagram-loki          Up
extagram-promtail      Up
extagram-prometheus    Up
extagram-cadvisor      Up
```

---

## Crear Dashboard

### Opció 1: Via API (Script Automatitzat)

**Script:** `init-grafana.sh`
```bash
#!/bin/bash

# Esperar a que Grafana estigui llest
until curl -s http://localhost:3000/grafana/api/health > /dev/null 2>&1; do
    sleep 2
done

# Crear datasource Prometheus
curl -X POST -H "Content-Type: application/json" \
  -u admin:admin123 \
  http://localhost:3000/grafana/api/datasources \
  -d '{
    "name": "Prometheus",
    "type": "prometheus",
    "url": "http://prometheus:9090",
    "access": "proxy",
    "isDefault": true
  }'

# Crear datasource Loki
curl -X POST -H "Content-Type: application/json" \
  -u admin:admin123 \
  http://localhost:3000/grafana/api/datasources \
  -d '{
    "name": "Loki",
    "type": "loki",
    "url": "http://loki:3100",
    "access": "proxy"
  }'

# Obtenir UIDs
LOKI_UID=$(curl -s -u admin:admin123 http://localhost:3000/grafana/api/datasources | jq -r '.[] | select(.type=="loki") | .uid')
PROM_UID=$(curl -s -u admin:admin123 http://localhost:3000/grafana/api/datasources | jq -r '.[] | select(.type=="prometheus") | .uid')

# Crear dashboard
curl -X POST -H "Content-Type: application/json" \
  -u admin:admin123 \
  http://localhost:3000/grafana/api/dashboards/db \
  -d @dashboard.json

echo "Grafana inicialitzat correctament"
```

**Executar:**
```bash
chmod +x init-grafana.sh
./init-grafana.sh
```

### Opció 2: Via Interfície Web

**Passos:**

1. Accedir a Grafana: https://extagram-grup3.duckdns.org/grafana/
2. Login amb admin / admin123
3. Configuration → Data Sources → Add data source
4. Seleccionar **Prometheus**:
   - URL: `http://prometheus:9090`
   - Access: Server (default)
   - Save & Test
5. Add data source → Seleccionar **Loki**:
   - URL: `http://loki:3100`
   - Access: Server (default)
   - Save & Test
6. Create → Dashboard → Add new panel
7. Afegir queries (veure secció Queries Útils)

---

## Auto-inicialització

### Crear Servei Systemd

**Arxiu:** `/etc/systemd/system/extagram-grafana-init.service`
```ini
[Unit]
Description=Inicializar Grafana Extagram
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
User=ubuntu
WorkingDirectory=/home/ubuntu/extagram-project/configuracions/docker
ExecStartPre=/bin/sleep 10
ExecStart=/home/ubuntu/extagram-project/configuracions/docker/init-grafana.sh
RemainAfterExit=yes
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

**Habilitar servei:**
```bash
sudo systemctl daemon-reload
sudo systemctl enable extagram-grafana-init.service
sudo systemctl start extagram-grafana-init.service
```

**Verificar:**
```bash
sudo systemctl status extagram-grafana-init.service
```

**Provar auto-init després de reboot:**
```bash
sudo reboot
# Esperar 2-3 minuts
sudo systemctl status extagram-grafana-init.service
# Ha de mostrar: Active (exited) amb exit code 0
```

---

## Queries Útils

### LogQL (Loki)

**1. Tots els logs d'un contenidor:**
```logql
{container_name="extagram-s2-php"}
```

**2. Logs amb errors:**
```logql
{job="docker"} |= "ERROR"
```

**3. Logs de NGINX amb codi 500:**
```logql
{container_name="extagram-s1-loadbalancer"} |= "HTTP/1.1 500"
```

**4. Rate d'errors per minut:**
```logql
rate({job="docker"} |= "ERROR"[1m])
```

**5. Filtrar múltiples contenidors:**
```logql
{container_name=~"extagram-(s2|s3)-php"}
```

### PromQL (Prometheus)

**1. CPU per contenidor:**
```promql
rate(container_cpu_usage_seconds_total{name=~"extagram.*"}[30s]) * 100
```

**2. Memòria per contenidor (MB):**
```promql
container_memory_usage_bytes{name=~"extagram.*"} / 1024 / 1024
```

**3. Network RX (bytes/s):**
```promql
rate(container_network_receive_bytes_total{name=~"extagram.*"}[30s])
```

**4. Network TX (bytes/s):**
```promql
rate(container_network_transmit_bytes_total{name=~"extagram.*"}[30s])
```

**5. Disk Read (bytes/s):**
```promql
rate(container_fs_reads_bytes_total{name=~"extagram.*"}[30s])
```

**6. Disk Write (bytes/s):**
```promql
rate(container_fs_writes_bytes_total{name=~"extagram.*"}[30s])
```

**7. Contenidors running:**
```promql
count(container_last_seen{name=~"extagram.*"})
```

---

## Troubleshooting

### Problema 1: Grafana - ERR_TOO_MANY_REDIRECTS

**Solució:**

**NGINX:**
```nginx
location /grafana/ {
    proxy_pass http://grafana:3000/grafana/;  # Incloure /grafana/ al final
}
```

**Grafana environment:**
```yaml
- GF_SERVER_ROOT_URL=https://extagram-grup3.duckdns.org/grafana/
- GF_SERVER_SERVE_FROM_SUB_PATH=true
```

### Problema 2: Loki - No container_name Label

**Solució:**

Utilitzar `docker_sd_configs` en comptes de `static_configs`:
```yaml
scrape_configs:
  - job_name: docker
    docker_sd_configs:
      - host: unix:///var/run/docker.sock
    relabel_configs:
      - source_labels: ['__meta_docker_container_name']
        regex: '/(.*)'
        target_label: 'container_name'
```

### Problema 3: Prometheus - No Metrics from cAdvisor

**Solució:**

Especificar `metrics_path` correcta:
```yaml
- job_name: 'cadvisor'
  metrics_path: '/cadvisor/metrics'  # NO /metrics
  static_configs:
    - targets: ['cadvisor:8080']
```

### Problema 4: Dashboard No Es Crea Automàticament

**Solució:**

**1. Verificar servei systemd:**
```bash
sudo journalctl -u extagram-grafana-init.service -n 50
```

**2. Executar script manualment:**
```bash
cd ~/extagram-project/configuracions/docker
./init-grafana.sh
```

**3. Verificar que jq està instal·lat:**
```bash
sudo apt install jq -y
```

---

## Verificació Final

### Checklist Complet

- [ ] Grafana accessible a https://extagram-grup3.duckdns.org/grafana/
- [ ] Datasource Prometheus configurat i funcionant
- [ ] Datasource Loki configurat i funcionant
- [ ] Dashboard "Extagram Docker Monitoring" creat
- [ ] Panell CPU mostra línies de tots els contenidors
- [ ] Panell Memòria mostra valors correctes
- [ ] Panell Logs mostra logs amb etiqueta container_name
- [ ] Prometheus targets "up" (cadvisor, prometheus)
- [ ] Loki rep logs de Promtail
- [ ] Servei systemd actiu i enabled
- [ ] Auto-init funciona després de reboot

---

**Document elaborat per:** Hamza  
**Data:** 10 de Març de 2026  
**Versió:** 1.0
