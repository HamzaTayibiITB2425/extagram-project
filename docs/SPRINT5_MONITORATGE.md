# Sprint 5 - Monitoratge i Automatització

## Índex

1. [Introducció](#introducció)
2. [Objectius del Sprint](#objectius-del-sprint)
3. [Arquitectura de Monitoratge](#arquitectura-de-monitoratge)
4. [Grafana](#grafana)
   - [Instal·lació i Configuració](#installació-i-configuració-grafana)
   - [Dashboard Principal](#dashboard-principal)
   - [Auto-inicialització](#auto-inicialització)
5. [Loki](#loki)
   - [Arquitectura Loki](#arquitectura-loki)
   - [Configuració](#configuració-loki)
   - [LogQL Queries](#logql-queries)
6. [Promtail](#promtail)
   - [Service Discovery Docker](#service-discovery-docker)
   - [Extracció d'Etiquetes](#extracció-detiquetes)
   - [Pipeline Stages](#pipeline-stages)
7. [Prometheus](#prometheus)
   - [Configuració Scraping](#configuració-scraping)
   - [PromQL Queries](#promql-queries)
8. [cAdvisor](#cadvisor)
   - [Mètriques Exposades](#mètriques-exposades)
9. [Automatització amb Ansible](#automatització-amb-ansible)
   - [Estructura Ansible](#estructura-ansible)
   - [Playbooks](#playbooks)
   - [Verificació Remota](#verificació-remota)
10. [Proves de Monitoratge](#proves-de-monitoratge)
11. [Conclusions](#conclusions)

---

## Introducció

El **Sprint 5** del projecte Extagram es va centrar en la implementació d'un sistema de monitoratge centralitzat amb **Grafana + Loki + Prometheus** i l'automatització del desplegament amb **Ansible**.

**Data d'execució:** 2 de Març de 2026 - 10 de Març de 2026  
**Durada:** 1 setmana  
**Estat:** COMPLETAT (10/03/2026)

Aquest document detalla l'arquitectura de monitoratge implementada, la configuració tècnica de cada component i la integració amb Ansible per desplegaments automatitzats.

---

## Objectius del Sprint

### Objectius Principals

1. **Implementar Grafana** com a plataforma de visualització unificada
2. **Configurar Loki** per agregació i indexació de logs
3. **Desplegar Prometheus** per monitoratge de mètriques
4. **Configurar Promtail** amb service discovery de Docker
5. **Crear dashboard funcional** amb panells de CPU, memòria, xarxa, logs
6. **Implementar auto-inicialització** amb servei systemd
7. **Automatitzar amb Ansible** per desplegaments repetibles

### Objectius Específics

- Centralitzar **logs de tots els contenidors** en Grafana
- Extreure etiqueta `container_name` per filtrar logs
- Monitoritzar **CPU, RAM, Network I/O, Disk I/O** en temps real
- Configurar **scrape interval de 5 segons** en Prometheus
- Crear dashboard que es **genera automàticament** al reiniciar
- Implementar **playbook Ansible** per verificació remota
- Documentar **guies d'instal·lació** completes

---

## Arquitectura de Monitoratge
```
Docker Containers (S1-S8)
       ↓
   Promtail (Logs) ────────→ Loki (Storage) ────────┐
       ↓                                             ↓
   cAdvisor (Mètriques) ───→ Prometheus (Storage) ──→ Grafana (Visualització)
                                                      ↑
                                              Dashboards + Alertes
```

### Components

| Component | Funció | Port | Xarxa |
|-----------|--------|------|-------|
| **Grafana** | Visualització logs i mètriques | 3000 | monitoring |
| **Loki** | Agregació i indexació de logs | 3100 | monitoring |
| **Promtail** | Recopilació logs Docker | 9080 | monitoring |
| **Prometheus** | Monitoratge mètriques | 9090 | monitoring |
| **cAdvisor** | Exposició mètriques contenidors | 8080 | monitoring |

### Flux de Dades

**1. Logs:**
```
Docker → Promtail (docker_sd_configs) → Loki → Grafana
```

**2. Mètriques:**
```
Contenidors → cAdvisor (/cadvisor/metrics) → Prometheus (scrape 5s) → Grafana
```

---

## Grafana

### Instal·lació i Configuració Grafana

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

**Variables d'entorn clau:**

- `GF_SERVER_ROOT_URL` - URL completa amb subpath `/grafana/`
- `GF_SERVER_SERVE_FROM_SUB_PATH=true` - Habilita subpath routing
- `GF_SERVER_DOMAIN` - Domini públic

**Accés:**
```
URL: https://extagram-grup3.duckdns.org/grafana/
Credencials: admin / admin123
```

### Dashboard Principal

**Dashboard: "Extagram Docker Monitoring"**

**UID:** `extagram-main`

**Panells implementats:**

#### 1. CPU Usage per Contenidor

**Query PromQL:**
```promql
rate(container_cpu_usage_seconds_total{name=~"extagram.*"}[30s]) * 100
```

**Configuració:**
- Tipus: Time Series
- Unitat: percent
- Legend: {{name}}
- Refresh: 5s

#### 2. Memòria Usage per Contenidor

**Query PromQL:**
```promql
container_memory_usage_bytes{name=~"extagram.*"} / 1024 / 1024
```

**Configuració:**
- Tipus: Time Series
- Unitat: megabytes
- Legend: {{name}}

#### 3. Network I/O per Contenidor

**Queries PromQL:**
```promql
# RX (Received)
rate(container_network_receive_bytes_total{name=~"extagram.*"}[30s])

# TX (Transmitted)
rate(container_network_transmit_bytes_total{name=~"extagram.*"}[30s])
```

**Configuració:**
- Tipus: Time Series
- Unitat: Bytes per segon
- Legend RX: {{name}} RX
- Legend TX: {{name}} TX

#### 4. Disk I/O per Contenidor

**Queries PromQL:**
```promql
# Read
rate(container_fs_reads_bytes_total{name=~"extagram.*"}[30s])

# Write
rate(container_fs_writes_bytes_total{name=~"extagram.*"}[30s])
```

#### 5. Contenedors Running

**Query PromQL:**
```promql
count(container_last_seen{name=~"extagram.*"})
```

**Configuració:**
- Tipus: Stat
- Mode: Value and Name
- Mostra número total de contenidors actius

#### 6. Container Logs

**Query LogQL:**
```logql
{job="docker"}
```

**Configuració:**
- Tipus: Logs
- Datasource: Loki
- Filtrat per `container_name`
- Mostra últims 100 logs
- Ordenació: Descendent (més recents primer)

#### 7. MySQL Connections

**Query PromQL:**
```promql
mysql_global_status_threads_connected
```

**Nota:** Requereix MySQL Exporter (opcional, no implementat en aquest sprint)

### Auto-inicialització

**Servei systemd:** `/etc/systemd/system/extagram-grafana-init.service`
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

**Script:** `init-grafana.sh`
```bash
#!/bin/bash

# Esperar a que Grafana estigui llest
until curl -s http://localhost:3000/grafana/api/health > /dev/null 2>&1; do
    echo "Esperando Grafana..."
    sleep 2
done

# Obtenir UIDs dels datasources
LOKI_UID=$(curl -s -u admin:admin123 http://localhost:3000/grafana/api/datasources | jq -r '.[] | select(.type=="loki") | .uid')
PROM_UID=$(curl -s -u admin:admin123 http://localhost:3000/grafana/api/datasources | jq -r '.[] | select(.type=="prometheus") | .uid')

# Crear datasource Prometheus
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

# Crear datasource Loki
curl -s -X POST -H "Content-Type: application/json" \
  -u admin:admin123 \
  http://localhost:3000/grafana/api/datasources \
  -d '{
    "name": "Loki",
    "type": "loki",
    "url": "http://loki:3100",
    "access": "proxy"
  }' > /dev/null 2>&1

# Actualitzar UIDs després de crear
LOKI_UID=$(curl -s -u admin:admin123 http://localhost:3000/grafana/api/datasources | jq -r '.[] | select(.type=="loki") | .uid')
PROM_UID=$(curl -s -u admin:admin123 http://localhost:3000/grafana/api/datasources | jq -r '.[] | select(.type=="prometheus") | .uid')

# Crear dashboard (JSON simplificat aquí)
curl -s -X POST -H "Content-Type: application/json" \
  -u admin:admin123 \
  http://localhost:3000/grafana/api/dashboards/db \
  -d "{...dashboard JSON...}" > /dev/null

# Configurar dashboard com a home
curl -s -X PUT -H "Content-Type: application/json" \
  -u admin:admin123 \
  http://localhost:3000/grafana/api/org/preferences \
  -d '{"homeDashboardUID":"extagram-main","theme":"dark"}' > /dev/null

echo "Grafana inicializado correctamente"
```

**Habilitar servei:**
```bash
sudo systemctl enable extagram-grafana-init.service
sudo systemctl start extagram-grafana-init.service
```

**Verificar:**
```bash
sudo systemctl status extagram-grafana-init.service
sudo journalctl -u extagram-grafana-init.service -n 50
```

---

## Loki

### Arquitectura Loki
```
Promtail → Loki (Port 3100) → Grafana
    ↓          ↓                  ↓
 Recopilació  Indexació       Visualització
   Logs      Etiquetes          Queries
```

### Configuració Loki

**Arxiu:** `monitoring/loki/loki-config.yml`
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

**Característiques:**
- **Retenció:** 7 dies
- **Ingestion rate:** Màxim 10 MB/s amb burst de 20 MB/s
- **Storage:** BoltDB per índexs, filesystem per chunks
- **Schema:** v11 (últim estable)

### LogQL Queries

**Exemples de queries:**
```logql
# Tots els logs d'un contenidor
{container_name="extagram-s2-php"}

# Logs amb errors
{job="docker"} |= "ERROR"

# Logs de NGINX amb codi 500
{container_name="extagram-s1-loadbalancer"} |= "HTTP/1.1 500"

# Rate d'errors per minut
rate({job="docker"} |= "ERROR"[1m])

# Filtrar per múltiples contenidors
{container_name=~"extagram-(s2|s3)-php"}

# Logs entre dates
{job="docker"} | json | line_format "{{.log}}"
```

---

## Promtail

### Service Discovery Docker

**Configuració clau:**
```yaml
scrape_configs:
  - job_name: docker
    docker_sd_configs:
      - host: unix:///var/run/docker.sock
        refresh_interval: 5s
```

**Avantatges:**
- **Detecció automàtica** de tots els contenidors
- **No cal configurar manualment** cada contenidor
- **Actualització dinàmica** cada 5 segons
- **Escalabilitat automàtica** - Nous contenidors es detecten automàticament

### Extracció d'Etiquetes

**relabel_configs:**
```yaml
relabel_configs:
  - source_labels: ['__meta_docker_container_name']
    regex: '/(.*)'
    target_label: 'container_name'
  
  - source_labels: ['__meta_docker_container_log_stream']
    target_label: 'stream'
```

**Procés:**
1. Docker proporciona `__meta_docker_container_name` → `/extagram-s2-php`
2. Regex `/(.*)`extreu → `extagram-s2-php`
3. Es crea label `container_name=extagram-s2-php`

**Resultat a Loki:**
```json
{
  "container_name": "extagram-s2-php",
  "stream": "stdout",
  "job": "docker"
}
```

### Pipeline Stages
```yaml
pipeline_stages:
  - docker: {}
```

El stage `docker` processa automàticament:
- Format JSON dels logs de Docker
- Extracció de timestamps
- Separació stdout/stderr
- Parsejat de camps

**Exemple de log processat:**

**Input (Docker):**
```json
{"log":"[2026-03-10 14:32:15] ERROR: Failed to connect\n","stream":"stderr","time":"2026-03-10T14:32:15Z"}
```

**Output (Loki):**
```
Timestamp: 2026-03-10T14:32:15Z
Stream: stderr
Container: extagram-s2-php
Message: [2026-03-10 14:32:15] ERROR: Failed to connect
```

---

## Prometheus

### Configuració Scraping

**Arxiu:** `monitoring/prometheus/prometheus.yml`
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

**Paràmetres:**
- **scrape_interval: 5s** - Recopila mètriques cada 5 segons
- **metrics_path: '/cadvisor/metrics'** - Ruta on cAdvisor exposa mètriques
- **targets: ['cadvisor:8080']** - Host i port de cAdvisor

### PromQL Queries

**Queries utilitzades al dashboard:**

**1. CPU total utilitzat:**
```promql
sum(rate(container_cpu_usage_seconds_total{name=~"extagram.*"}[1m])) * 100
```

**2. Top 3 contenidors per memòria:**
```promql
topk(3, container_memory_usage_bytes{name=~"extagram.*"})
```

**3. Tràfic de xarxa total:**
```promql
sum(rate(container_network_receive_bytes_total[1m])) + sum(rate(container_network_transmit_bytes_total[1m]))
```

**4. Percentatge de memòria utilitzada:**
```promql
(container_memory_usage_bytes / container_spec_memory_limit_bytes) * 100
```

---

## cAdvisor

### Mètriques Exposades

**URL:** `http://cadvisor:8080/cadvisor/metrics`

**Configuració:**
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

**Mètriques principals:**
- `container_cpu_usage_seconds_total` - Temps de CPU
- `container_memory_usage_bytes` - Memòria RAM
- `container_network_receive_bytes_total` - Bytes rebuts
- `container_network_transmit_bytes_total` - Bytes enviats
- `container_fs_reads_bytes_total` - Lectura disc
- `container_fs_writes_bytes_total` - Escriptura disc
- `container_last_seen` - Últim heartbeat

---

## Automatització amb Ansible

### Estructura Ansible
```
ansible/
├── README.md
├── inventory.yml
├── playbooks/
│   ├── deploy-full.yml
│   └── verify.yml
├── scripts/
│   └── shortcuts.sh
└── docs/
    ├── INSTALL.md
    ├── COMMANDS.md
    └── TROUBLESHOOTING.md
```

### Playbooks

**deploy-full.yml:**
```yaml
---
- name: Desplegar Extagram completo en producción
  hosts: extagram-server
  become: yes
  
  tasks:
    - name: Verificar que Docker funciona
      command: docker ps
      changed_when: false
      tags: [docker, verify]
    
    - name: Verificar estado de certificado SSL
      stat:
        path: "/etc/letsencrypt/live/{{ domain_name }}/fullchain.pem"
      register: ssl_cert
      tags: [ssl, verify]
    
    - name: Verificar servicios Docker corriendo
      shell: "docker ps --format 'table {{ '{{' }}.Names{{ '}}' }}\\t{{ '{{' }}.Status{{ '}}' }}' | grep extagram"
      register: docker_services
      changed_when: false
      failed_when: false
      tags: [verify]
    
    - name: Verificar servicio systemd
      systemd:
        name: extagram-grafana-init
      register: systemd_status
      failed_when: false
      tags: [monitoring, verify]
    
    - name: Verificar acceso HTTPS
      uri:
        url: "https://{{ domain_name }}/health"
        validate_certs: no
        status_code: 200
      register: health_check
      retries: 3
      delay: 5
      failed_when: false
      tags: [verify]
```

### Verificació Remota

**Comandes útils:**
```bash
# Verificar estat complet
ansible-playbook -i inventory.yml playbooks/deploy-full.yml --tags verify

# Ver logs d'un contenidor
ansible extagram-server -i inventory.yml -m shell -a "docker logs extagram-grafana --tail 50"

# Reiniciar servei
ansible extagram-server -i inventory.yml -m shell -a "docker compose restart s1-loadbalancer"

# Ver estat contenidors
ansible extagram-server -i inventory.yml -m shell -a "docker ps"
```

---

## Proves de Monitoratge

### 1. Verificar Logs a Loki
```bash
# Comprovar que Loki rep logs
curl -s http://localhost:3100/loki/api/v1/label/container_name/values | jq

# Esperat: Llista de noms de contenidors
{
  "status": "success",
  "data": [
    "extagram-s1-loadbalancer",
    "extagram-s2-php",
    "extagram-s3-php",
    ...
  ]
}
```

### 2. Verificar Mètriques a Prometheus
```bash
# Comprovar targets
curl -s http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | {job: .labels.job, health: .health}'

# Esperat:
{
  "job": "cadvisor",
  "health": "up"
}
{
  "job": "prometheus",
  "health": "up"
}
```

### 3. Verificar Dashboard a Grafana
```bash
# Comprovar que el dashboard existeix
curl -s -u admin:admin123 http://localhost:3000/grafana/api/search | grep "Extagram Docker Monitoring"

# Esperat: JSON amb el dashboard
```

### 4. Verificar Auto-inicialització
```bash
# Reiniciar sistema
sudo reboot

# Després del reboot (esperar 2-3 minuts):
sudo systemctl status extagram-grafana-init.service

# Esperat: Active (exited) amb exit code 0
```

### 5. Verificar Etiqueta container_name
```bash
# A Grafana Explore, executar:
{job="docker"} | logfmt | container_name != ""

# Esperat: Logs amb etiqueta container_name visible
```

---

## Conclusions

### Assoliments

1. **Grafana operatiu** amb dashboard funcional i 7 panells
2. **Loki agregant logs** de tots els contenidors amb etiqueta `container_name`
3. **Prometheus scrapeant** mètriques de cAdvisor cada 5 segons
4. **Auto-inicialització** amb servei systemd funcionant correctament
5. **Ansible funcional** per verificació i gestió remota
6. **Documentació completa** d'instal·lació i troubleshooting

### Reptes Superats

**1. Configuració de subpath en Grafana**

**Problema:** ERR_TOO_MANY_REDIRECTS quan Grafana estava en `/grafana/`

**Solució:**
```nginx
# NGINX
location /grafana/ {
    proxy_pass http://grafana:3000/grafana/;  # Incloure /grafana/ al final
}
```
```yaml
# Grafana
environment:
  - GF_SERVER_ROOT_URL=https://extagram-grup3.duckdns.org/grafana/
  - GF_SERVER_SERVE_FROM_SUB_PATH=true
```

**2. Extracció etiqueta container_name**

**Problema:** Promtail no extreia el nom del contenidor correctament

**Solució:** Utilitzar `docker_sd_configs` amb `relabel_configs`
```yaml
relabel_configs:
  - source_labels: ['__meta_docker_container_name']
    regex: '/(.*)'
    target_label: 'container_name'
```

**3. cAdvisor amb url_base_prefix**

**Problema:** Prometheus no trobava les mètriques de cAdvisor

**Solució:**
```yaml
# Prometheus
- job_name: 'cadvisor'
  metrics_path: '/cadvisor/metrics'  # Especificar ruta completa
```

### Lliçons Apreses

- **Service discovery de Docker** simplifica enormement la configuració de Promtail
- Els **UIDs de datasources** són dinàmics i s'han d'obtenir en temps d'execució
- La **auto-inicialització amb systemd** garanteix la disponibilitat després de reinicis
- **Ansible** facilita la verificació remota i desplegaments repetibles
- La **documentació exhaustiva** és essencial per manteniment futur

### Millores Futures

- Afegir **alertes automàtiques** a Grafana per anomalies
- Implementar **MySQL Exporter** per monitoritzar connexions BD
- Configurar **retention policies** més granulars a Loki
- Crear **dashboards addicionals** per serveis específics (NGINX, MySQL, LDAP)
- Integrar **Jaeger** per distributed tracing

---

**Document elaborat per:** Hamza  
**Data:** 10 de Març de 2026  
**Versió:** 1.0  
**Estat:** COMPLETAT
