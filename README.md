<div align="center">
  <h1>Projecte Extagram - Sistema d'Alta Disponibilitat</h1>
</div>

<div align="center">

![Status](https://img.shields.io/badge/Status-Sprint%205%20Pendent-yellow)
![Sprint](https://img.shields.io/badge/Sprint-4%2F5-orange)
![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker)
![Agile](https://img.shields.io/badge/Methodology-Agile%20Scrum-green)
![Security](https://img.shields.io/badge/Security-WAF%20%2B%20Hardening-red)

**Aplicació web de xarxes socials amb arquitectura de microserveis**  
*Institut Tecnològic de Barcelona - ASIX2c*

</div>

---

## Taula de Continguts

1. [Informació del Projecte](#informació-del-projecte)
2. [Equip de Treball](#equip-de-treball)
3. [Objectius del Projecte](#objectius-del-projecte)
4. [Arquitectura del Sistema](#arquitectura-del-sistema)
5. [Proves de Segmentació de Xarxa](#proves-de-segmentació-de-xarxa)
6. [Tecnologies Utilitzades](#tecnologies-utilitzades)
7. [Planificació de Sprints](#planificació-de-sprints)
8. [Guia d'Instal·lació](#guia-dinstal·lació)
9. [Proves i Validació](#proves-i-validació)
10. [Documentació](#documentació)
11. [Control de Versions](#control-de-versions)
12. [Contacte](#contacte)

---

## Informació del Projecte

| Camp | Valor |
|------|-------|
| **Mòdul** | 0379 - Projecte intermodular d'administració de sistemes informàtics en xarxa |
| **Activitat** | P0.1 - Desplegament aplicació Extagram amb Alta Disponibilitat |
| **Institut** | Institut Tecnològic de Barcelona |
| **Curs** | ASIX2c (Administració de Sistemes Informàtics en Xarxa) |
| **Tutor del Projecte** | Jordi Casas |
| **Data d'Inici** | 15 de Desembre de 2025 |
| **Data de Finalització** | 17 de Març de 2026 |
| **Durada Total** | 13 setmanes (5 sprints) |
| **Hores Estimades** | 180 hores totals |
| **Repositori GitHub** | [github.com/HamzaTayibiITB2425/extagram-project](https://github.com/HamzaTayibiITB2425/extagram-project) |

---

## Equip de Treball

| Membre | Rol Principal | Responsabilitats Clau |
|--------|---------------|------------------------|
| **Hamza** | Product Owner / DevOps Lead | Gestió del projecte, Docker, PHP, MySQL, LDAP, WAF, Hardening, Monitoratge |
| **Kevin** | Infrastructure Engineer | NGINX, Load Balancer, Segmentació de xarxa, Firewall, Proves d'estrès |

### Distribució de Tasques per Sprint

**Hamza:**
- Sprint 1: Planning, Documentació, Git, PHP-FPM, MySQL, Backend
- Sprint 2: Docker Compose, Orquestració, Dockerfiles, LDAP, Segmentació
- Sprint 3: Documentació final, Testing, Proves
- Sprint 4: WAF NGINX, Hardening OS, Hardening MySQL
- Sprint 5: Grafana, Loki, Prometheus, Dashboard

**Kevin:**
- Sprint 1: NGINX, Infraestructura
- Sprint 2: Load Balancer, Proxy, Segmentació de Xarxa
- Sprint 3: Packet Tracer, Diagrames
- Sprint 4: Firewall iptables, Proves de seguretat
- Sprint 5: Proves d'estrès, Dashboard rendiment

---

## Objectius del Projecte

### Objectiu General

Desenvolupar i desplegar una aplicació web de xarxes socials (Extagram) amb una **arquitectura d'alta disponibilitat** basada en microserveis containeritzats, implementant **balanceig de càrrega**, **redundància de serveis**, **segmentació de xarxa en 3 capes**, **seguretat amb WAF i hardening**, i **sistema de monitoratge centralitzat**.

### Objectius Específics

**Objectius Tècnics:**
- Implementar arquitectura de 8 serveis independents (S1-S8)
- Configurar balanceig de càrrega Round-Robin entre nodes PHP
- Garantir persistència de dades amb volums Docker
- Configurar segmentació de xarxa en 3 capes aïllades
- Implementar autenticació LDAP
- Desplegar WAF NGINX natiu
- Aplicar hardening a contenidors i base de dades
- Implementar firewall iptables
- Centralitzar logs amb Grafana + Loki
- Monitoritzar mètriques amb Prometheus

**Objectius d'Alta Disponibilitat:**
- Redundància de nodes d'aplicació (S2 i S3)
- Tolerància a fallades
- Recuperació automàtica de contenidors
- Escalabilitat horitzontal

**Objectius de Seguretat:**
- Aïllament de la capa de dades
- Segmentació de xarxa (3 xarxes separades)
- Principi de mínim privilegi
- WAF NGINX (SQL Injection, XSS, Path Traversal, Rate Limiting)
- Hardening de contenidors (no-new-privileges, cap_drop, read_only)
- Hardening de MySQL (usuaris mínims, privilegis restringits)
- Firewall iptables perimetral

---

## Arquitectura del Sistema

### Components del Sistema

| Servei | Nom | Imatge Docker | Port | Funció | Xarxes |
|--------|-----|---------------|------|--------|--------|
| **S1** | Load Balancer + WAF | nginx:alpine | 80, 443 | Proxy invers, balanceig Round-Robin i WAF | extagram_front, extagram_services |
| **S2** | PHP Backend 1 | php:8.2-fpm-alpine | 9000 | Execució lògica aplicació (Redundància) | extagram_services, extagram_data |
| **S3** | PHP Backend 2 | php:8.2-fpm-alpine | 9000 | Execució lògica aplicació (Redundància) | extagram_services, extagram_data |
| **S4** | Upload Service | php:8.2-fpm-alpine | 9000 | Gestió de pujada i eliminació d'arxius | extagram_services, extagram_data |
| **S5** | Image Server | nginx:alpine | 80 | Servir imatges pujades (read-only) | extagram_services |
| **S6** | Static Server | nginx:alpine | 80 | Servir CSS, SVG i favicon | extagram_services |
| **S7** | Database | mysql:8.0 | 3306 | Emmagatzematge de posts i metadata | extagram_data (internal) |
| **S8** | LDAP Server | osixia/openldap:1.5.0 | 389/636 | Autenticació d'usuaris | extagram_data (internal) |

### Segmentació de Xarxa
```
extagram_front (172.20.0.x)
   └── S1: Load Balancer + WAF (exposat a Internet via port 80/443)

extagram_services (172.19.0.x)
   └── S1, S2, S3, S4, S5, S6 (comunicació interna aplicació)

extagram_data (172.21.0.x - INTERNAL)
   └── S2, S3, S4, S7, S8 (capa de dades aïllada)
```

---

## Proves de Segmentació de Xarxa

### Connexions Permeses

**Capa de Dades (S2/S3/S4 → S7/S8):**

Els serveis PHP poden accedir a MySQL i LDAP:
```bash
# S2 → S7 (MySQL)
docker exec extagram-s2-php ping -c 2 -W 2 172.21.0.2
# Resultat: CORRECTE - 2 packets transmitted, 2 received

# S3 → S7 (MySQL)
docker exec extagram-s3-php ping -c 2 -W 2 172.21.0.2
# Resultat: CORRECTE - 2 packets transmitted, 2 received

# S4 → S7 (MySQL)
docker exec extagram-s4-upload ping -c 2 -W 2 172.21.0.2
# Resultat: CORRECTE - 2 packets transmitted, 2 received

# S2 → S8 (LDAP)
docker exec extagram-s2-php ping -c 2 -W 2 172.21.0.3
# Resultat: CORRECTE - 2 packets transmitted, 2 received

# S3 → S8 (LDAP)
docker exec extagram-s3-php ping -c 2 -W 2 172.21.0.3
# Resultat: CORRECTE - 2 packets transmitted, 2 received
```

**Load Balancer (S1 → S2/S3/S4/S5/S6):**

El Load Balancer pot accedir a tots els serveis d'aplicació:
```bash
# S1 → S2
docker exec extagram-s1-loadbalancer ping -c 2 -W 2 s2-php
# Resultat: CORRECTE

# S1 → S3
docker exec extagram-s1-loadbalancer ping -c 2 -W 2 s3-php
# Resultat: CORRECTE

# S1 → S4
docker exec extagram-s1-loadbalancer ping -c 2 -W 2 s4-upload
# Resultat: CORRECTE

# S1 → S5
docker exec extagram-s1-loadbalancer ping -c 2 -W 2 s5-images
# Resultat: CORRECTE

# S1 → S6
docker exec extagram-s1-loadbalancer ping -c 2 -W 2 s6-static
# Resultat: CORRECTE
```

### Connexions Bloquejades

**Servidors estàtics (S5/S6) NO poden accedir a base de dades:**
```bash
# S5 → S7 (MySQL)
docker exec extagram-s5-images ping -c 2 -W 2 172.21.0.2
# Resultat: BLOQUEADO - Network unreachable

# S5 → S8 (LDAP)
docker exec extagram-s5-images ping -c 2 -W 2 172.21.0.3
# Resultat: BLOQUEADO - Network unreachable

# S6 → S7 (MySQL)
docker exec extagram-s6-static ping -c 2 -W 2 172.21.0.2
# Resultat: BLOQUEADO - Network unreachable

# S6 → S8 (LDAP)
docker exec extagram-s6-static ping -c 2 -W 2 172.21.0.3
# Resultat: BLOQUEADO - Network unreachable
```

**Load Balancer (S1) NO pot accedir directament a base de dades:**
```bash
# S1 → S7 (MySQL)
docker exec extagram-s1-loadbalancer ping -c 2 -W 2 s7-database
# Resultat: BLOQUEADO - Name or service not known

# S1 → S8 (LDAP)
docker exec extagram-s1-loadbalancer ping -c 2 -W 2 s8-ldap
# Resultat: BLOQUEADO - Name or service not known
```

### Resum de Seguretat

La segmentació de xarxa garanteix:
- Cap servei estàtic (S5, S6) pot accedir a dades sensibles
- El load balancer (S1) no pot saltar-se la lògica de negoci
- La capa de dades (extagram_data) està completament aïllada
- Només els serveis PHP (S2, S3, S4) fan de pont autoritzat

---

## Tecnologies Utilitzades

| Component | Tecnologia | Versió | Ús |
|-----------|------------|--------|-----|
| Containerització | Docker | Latest | Orquestració de serveis |
| Orquestració | Docker Compose | v2.x | Definició multi-contenidor |
| Proxy / Load Balancer | NGINX | Alpine | S1, S5, S6 |
| WAF | NGINX Native | Latest | Protecció web |
| Firewall | iptables | Latest | Protecció perimetral |
| Backend | PHP-FPM | 8.2-Alpine | S2, S3, S4 |
| Base de Dades | MySQL | 8.0 | S7 |
| Autenticació | OpenLDAP | 1.5.0 | S8 |
| Monitoratge | Grafana + Loki + Prometheus | Latest | Logs i mètriques |

---

## Planificació de Sprints

### Cronograma General

| Sprint | Data Inici | Data Fi | Durada | Objectiu | Estat | Documents |
|--------|------------|---------|--------|----------|-------|-----------|
| Sprint 0 | 08/12/2025 | 14/12/2025 | 1 setmana | Preparació inicial | COMPLETAT | - |
| Sprint 1 | 15/12/2025 | 19/01/2026 | 5 setmanes | MVP en màquina única | COMPLETAT | [Planning](actes/sprint1/SPRINT1_PLANNING.md) - [Review](actes/sprint1/SPRINT1_REVIEW.md) |
| Sprint 2 | 20/01/2026 | 02/02/2026 | 2 setmanes | Dockerització i balanceig | COMPLETAT | [Planning](actes/sprint2/SPRINT2_PLANNING.md) - [Review](actes/sprint2/SPRINT2_REVIEW.md) |
| Sprint 3 | 03/02/2026 | 10/02/2026 | 1 setmana | Integració i proves | COMPLETAT | [Planning](actes/sprint3/SPRINT3_PLANNING.md) - [Review](actes/sprint3/SPRINT3_REVIEW.md) |
| Sprint 4 | 17/02/2026 | 23/02/2026 | 1 setmana | Seguretat (WAF, Hardening) | COMPLETAT | [Planning](actes/sprint4/SPRINT4_PLANNING.md) - [Review](actes/sprint4/SPRINT4_REVIEW.md) - [Retrospectiva](actes/sprint4/SPRINT4_RETROSPECTIVA.md) |
| Sprint 5 | 02/03/2026 | 10/03/2026 | 1 setmana | Monitoratge | PENDENT | - |
| Presentació | 16/03/2026 | 17/03/2026 | 2 dies | Defensa del projecte | PENDENT | - |

### Mètriques de Seguretat (Sprint 4)

| Mètrica | Abans | Després | Millora |
|---------|-------|---------|---------|
| SQL Injection bloqueats | 0% | 100% | +100% |
| XSS bloqueats | 0% | 100% | +100% |
| Path Traversal bloqueats | 0% | 100% | +100% |
| Security Headers | 0/4 | 4/4 | +100% |
| Rate Limiting | No | 10 req/s | Implementat |
| Contenidors hardened | 0/8 | 8/8 | +100% |
| MySQL fortificat | No | Sí | Implementat |
| Firewall perimetral | No | iptables | Implementat |

### Progrés Global
```
Sprint 1: [####################] 100% COMPLETAT
Sprint 2: [####################] 100% COMPLETAT
Sprint 3: [####################] 100% COMPLETAT
Sprint 4: [####################] 100% COMPLETAT
Sprint 5: [                    ]   0% PENDENT

Total:    [################    ]  80% (4/5 sprints)
```

---

## Guia d'Instal·lació

### Pre-requisits

- Sistema Operatiu: Ubuntu Server 22.04 LTS
- Docker: 24.0.0 o superior
- Docker Compose: v2.20.0 o superior
- Git: 2.34.0 o superior
- Memòria RAM: Mínim 4GB (Recomanat 8GB)
- Disc: Mínim 20GB lliures

### Passos d'Instal·lació
```bash
# 1. Clonar el repositori
git clone https://github.com/HamzaTayibiITB2425/extagram-project.git
cd extagram-project/configuracions/docker

# 2. Configurar variables d'entorn
# Copiar .env.example i editar amb credencials segures
cp .env.example .env
nano .env

# 3. Aixecar els contenidors
docker compose up -d

# 4. Verificar que tot està UP
docker compose ps

# 5. Accedir a l'aplicació
# Navegador: https://extagram-grup3.duckdns.org
```

**IMPORTANT - Seguretat:**
- MAI exposar credencials reals en documentació pública
- Utilitzar contrasenyes fortes i úniques
- El fitxer .env està a .gitignore per evitar exposició
- Consultar .env.example per veure variables necessàries

---

## Proves i Validació

### Proves de Funcionalitat

**Accés web HTTPS:**
```bash
curl -I https://extagram-grup3.duckdns.org/extagram.php
# Esperat: HTTP/2 200 OK
```

**Balanceig Round-Robin:**
```bash
for i in {1..10}; do 
  curl -s https://extagram-grup3.duckdns.org/extagram.php | grep "hostname"
done
# Esperat: Alternància entre s2-php i s3-php
```

**Upload d'imatges:**
```bash
curl -X POST -F "caption=Test" -F "photo=@test.jpg" \
  https://extagram-grup3.duckdns.org/upload.php
# Esperat: HTTP 302 Redirect
```

### Proves de Seguretat WAF

**Bloqueig SQL Injection:**
```bash
curl -i "https://extagram-grup3.duckdns.org/extagram.php?id=1'%20OR%20'1'='1"
# Esperat: HTTP 403 - WAF: SQL Injection Blocked
```

**Bloqueig XSS:**
```bash
curl -i "https://extagram-grup3.duckdns.org/extagram.php?search=<script>alert(1)</script>"
# Esperat: HTTP 403 - WAF: XSS Attack Blocked
```

**Bloqueig Path Traversal:**
```bash
curl -i "https://extagram-grup3.duckdns.org/../../../etc/passwd"
# Esperat: HTTP 403 - WAF: Path Traversal Blocked
```

### Proves de Hardening

**Filesystem read-only:**
```bash
docker exec extagram-s2-php touch /test.txt
# Esperat: Read-only file system
```

**Privilegis MySQL limitats:**
```bash
docker exec extagram-s7-database mysql -u extagram_admin -p \
  -e "CREATE DATABASE hack;"
# Esperat: Access denied
```

**Verificació hardening contenidors:**
```bash
# Verificar no-new-privileges
docker inspect extagram-s2-php --format='{{.HostConfig.SecurityOpt}}'
# Esperat: [no-new-privileges:true]

# Verificar read-only
docker inspect extagram-s2-php --format='{{.HostConfig.ReadonlyRootfs}}'
# Esperat: true

# Verificar cap_drop
docker inspect extagram-s2-php --format='{{.HostConfig.CapDrop}}'
# Esperat: [ALL]
```

**Verificació hardening MySQL:**
```bash
# Verificar usuaris MySQL
docker exec extagram-s7-database mysql -u root -p -e "SELECT user, host FROM mysql.user;"

# Verificar privilegis extagram_admin
docker exec extagram-s7-database mysql -u root -p -e "SHOW GRANTS FOR 'extagram_admin'@'%';"

# Verificar que root només és local
docker exec extagram-s7-database mysql -u root -p -e "SELECT user, host FROM mysql.user WHERE user='root';"
```

---

## Documentació

### Actes de Sprints

- Sprint 1: [Planning](actes/sprint1/SPRINT1_PLANNING.md) - [Review](actes/sprint1/SPRINT1_REVIEW.md)
- Sprint 2: [Planning](actes/sprint2/SPRINT2_PLANNING.md) - [Review](actes/sprint2/SPRINT2_REVIEW.md)
- Sprint 3: [Planning](actes/sprint3/SPRINT3_PLANNING.md) - [Review](actes/sprint3/SPRINT3_REVIEW.md)
- Sprint 4: [Planning](actes/sprint4/SPRINT4_PLANNING.md) - [Review](actes/sprint4/SPRINT4_REVIEW.md) - [Retrospectiva](actes/sprint4/SPRINT4_RETROSPECTIVA.md)

---

## Control de Versions

### Estratègia de Branques
```
main (producció)
│
├── develop (desenvolupament)
│   ├── feature/s1-loadbalancer
│   ├── feature/s2-php-backend
│   ├── feature/waf-implementation
│   └── feature/grafana-monitoring
│
└── hotfix/critical-bug (si cal)
```

### Convencions de Commits
```bash
feat(s1): afegir configuració WAF NGINX
fix(s4): corregir permisos upload
docs(readme): actualitzar arquitectura
security(mysql): aplicar hardening
test(waf): afegir proves SQL injection
```

---

## Contacte

### Equip del Projecte

**Hamza** (Product Owner / DevOps Lead)
- GitHub: [@HamzaTayibiITB2425](https://github.com/HamzaTayibiITB2425)
- Email: hamza.tayibi@itb.cat

**Kevin** (Infrastructure Engineer)
- GitHub: [@KevinITB](https://github.com/KevinITB)
- Email: kevin@itb.cat

### Tutor del Projecte

**Jordi Casas**
- Email: jordi.casas@itb.cat
- Institut Tecnològic de Barcelona

---

## Llicència

Aquest projecte està sota llicència MIT License. Vegeu el fitxer LICENSE per més detalls.

Copyright 2025-2026 Hamza, Kevin - Institut Tecnològic de Barcelona

---

<div align="center">

**Projecte Extagram - Institut Tecnològic de Barcelona**  
**Equip:** Hamza, Kevin | **ASIX2c** | **2025-2026**

[![GitHub](https://img.shields.io/badge/GitHub-Repository-black?logo=github)](https://github.com/HamzaTayibiITB2425/extagram-project)
[![Docker](https://img.shields.io/badge/Docker-Containerized-2496ED?logo=docker)](https://www.docker.com/)
[![NGINX](https://img.shields.io/badge/NGINX-Load%20Balancer-009639?logo=nginx)](https://nginx.org/)

**Última actualització:** 24 de Febrer de 2026  
**Versió:** 10.0  
**Estat:** EN DESENVOLUPAMENT (80% completat)

</div>
