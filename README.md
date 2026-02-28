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

[Documentació](#documentació) • [Instal·lació](#guia-dinstal·lació-ràpida) • [Equip](#equip-de-treball) • [Planificació](#planificació-de-sprints)

</div>

---

## Índex

1. [Informació del Projecte](#informació-del-projecte)
2. [Equip de Treball](#equip-de-treball)
3. [Objectius del Projecte](#objectius-del-projecte)
4. [Arquitectura del Sistema](#arquitectura-del-sistema)
5. [Proves de Segmentació de Xarxa](#proves-de-segmentació-de-xarxa)
6. [Tecnologies Utilitzades](#tecnologies-utilitzades)
   - [Comparativa de Tecnologies](#comparativa-i-justificació-de-tecnologies)
7. [Planificació de Sprints](#planificació-de-sprints)
8. [Guia d'Instal·lació Ràpida](#guia-dinstal·lació-ràpida)
9. [Estructura del Repositori](#estructura-del-repositori)
10. [Proves i Validació](#proves-i-validació)
11. [Documentació](#documentació)
12. [Gestió de Riscos](#gestió-de-riscos)
13. [Metodologia Agile](#metodologia-agile)
14. [Control de Versions](#control-de-versions)
15. [Contacte i Suport](#contacte-i-suport)

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

| Membre | Rol Principal | Responsabilitats Clau | Competències |
|--------|---------------|------------------------|--------------|
| **Hamza** | Product Owner / DevOps Lead | Gestió del projecte i coordinació d'equip<br>Documentació tècnica i actes<br>Configuració Docker i Docker Compose<br>Integració contínua<br>Desenvolupament backend PHP<br>Administració base de dades MySQL i LDAP<br>Implementació WAF i Hardening<br>Sistema de monitoratge centralitzat | Lideratge, Organització, Docker, Git, PHP, MySQL, LDAP, Seguretat, Grafana |
| **Kevin** | Infrastructure Engineer / Security | Configuració NGINX i proxy invers<br>Implementació balanceig de càrrega<br>Gestió d'arxius estàtics<br>Diagrama de xarxa interactiu<br>Segmentació de xarxa<br>Implementació Firewall<br>Proves d'estrès i rendiment | NGINX, Networking, HTML/CSS, Infraestructura, Firewall, Testing |

### Distribució de Tasques per Sprint
```
Hamza (Product Owner / DevOps / Backend / Security):
├── Sprint 1: Planning, Documentació, Git, PHP-FPM, MySQL, Backend [COMPLETAT]
├── Sprint 2: Docker Compose, Orquestració, Dockerfiles, LDAP, Segmentació [COMPLETAT]
├── Sprint 3: Docs finals, Presentació, Testing, Proves [COMPLETAT]
├── Sprint 4: WAF NGINX, Hardening OS, Hardening MySQL [COMPLETAT]
└── Sprint 5: Grafana, Loki, Prometheus, Dashboard [PENDENT]

Kevin (Infrastructure Engineer / Security):
├── Sprint 1: NGINX, Infraestructura [COMPLETAT]
├── Sprint 2: Load Balancer, Proxy, Segmentació de Xarxa [COMPLETAT]
├── Sprint 3: Packet Tracer, Diagrames, Documentació [COMPLETAT]
├── Sprint 4: Firewall iptables davant S1, Proves seguretat [COMPLETAT]
└── Sprint 5: Proves d'estrès, Dashboard rendiment [PENDENT]
```

---

## Objectius del Projecte

### Objectiu General

Desenvolupar i desplegar una aplicació web de xarxes socials (Extagram) amb una **arquitectura d'alta disponibilitat** basada en microserveis containeritzats, implementant **balanceig de càrrega**, **redundància de serveis**, **segmentació de xarxa en 3 capes**, **seguretat amb WAF i hardening**, i **sistema de monitoratge centralitzat** per garantir la continuïtat del servei, seguretat i observabilitat davant fallades o compromisos de components individuals.

### Objectius Específics

#### Objectius Tècnics

- Implementar una arquitectura de **8 serveis independents** (S1-S8)
- Configurar **balanceig de càrrega Round-Robin** entre nodes PHP
- Establir **separació de responsabilitats** (SoC - Separation of Concerns)
- Garantir **persistència de dades** amb volums Docker
- Implementar **proxy invers** per a gestió centralitzada de peticions
- Configurar **segmentació de xarxa en 3 capes** aïllades (front, services, data)
- Implementar **autenticació LDAP** per a gestió d'usuaris
- Desplegar **WAF NGINX natiu** per protecció contra atacs web
- Aplicar **hardening** a contenidors i base de dades
- Implementar **firewall iptables** per protecció perimetral
- Centralitzar **logs amb Grafana + Loki**
- Monitoritzar **mètriques amb Prometheus**

#### Objectius d'Alta Disponibilitat

- **Redundància de nodes d'aplicació** (S2 i S3 funcionant en paral·lel)
- **Tolerància a fallades** - El sistema continua operant amb la caiguda d'un node PHP
- **Recuperació automàtica** de contenidors amb `restart: unless-stopped`
- **Escalabilitat horitzontal** - Capacitat d'afegir més nodes PHP si cal

#### Objectius de Seguretat

- **Aïllament de la capa de dades** - S7 (MySQL) i S8 (LDAP) NO accessibles des d'Internet
- **Segmentació de xarxa** - 3 xarxes separades amb regles de firewall
- **Principi de mínim privilegi** - Serveis estàtics NO tenen accés a base de dades
- **Xarxa interna** - `extagram_data` configurada com `internal: true`
- **WAF NGINX** - Protecció contra SQL Injection, XSS, Path Traversal, Rate Limiting
- **Hardening de contenidors** - `no-new-privileges`, `cap_drop: ALL`, `read_only` filesystem
- **Hardening de MySQL** - Usuaris mínims, privilegis restringits, configuració segura
- **Firewall iptables** - Protecció perimetral davant de S1-LoadBalancer

#### Objectius de Monitoratge

- **Centralització de logs** - Grafana + Loki per visualització unificada
- **Monitoratge de mètriques** - Prometheus per temps real
- **Dashboard de rendiment** - Visualització de CPU, RAM, requests/s
- **Alertes automàtiques** - Notificacions davant anomalies

#### Objectius de Gestió de Projecte

- Aplicar **metodologia Agile Scrum** amb 5 sprints
- Utilitzar **ProofHub** per a gestió de tasques i seguiment
- Mantenir **backlog de projecte** actualitzat
- Celebrar **dailies**, **sprint planning**, **sprint review** i **retrospectives**
- Documentar tot el procés amb **Markdown al repositori Git**

#### Objectius d'Aprenentatge

- Aprendre i aplicar **Docker i Docker Compose** per a orquestració
- Dominar configuració de **NGINX** com a load balancer i proxy invers
- Entendre arquitectures de **microserveis** i les seves avantatges
- Implementar **segmentació de xarxa** per a seguretat
- Configurar **OpenLDAP** per a autenticació centralitzada
- Desplegar **WAF NGINX natiu** per protecció web
- Configurar **iptables** per firewall Linux
- Aplicar **hardening** a contenidors i base de dades
- Implementar **Grafana + Loki + Prometheus** per monitoratge
- Realitzar **proves d'estrès** amb Apache Bench
- Desenvolupar habilitats de **treball en equip** i **comunicació tècnica**
- Adquirir experiència en **documentació tècnica professional**

---

## Arquitectura del Sistema

### Diagrama d'Arquitectura

El sistema Extagram està organitzat en **8 contenidors Docker** distribuïts en **3 xarxes segmentades** per garantir l'aïllament i seguretat de les capes de l'aplicació.

![Diagrama d'Arquitectura Extagram](docs/imagenes/arquitectura/diagrama_completo.jpg)

### Components del Sistema

| Servei | Nom | Imatge Docker | Port | Funció | Xarxes | Adreces IP |
|--------|-----|---------------|------|--------|--------|------------|
| **S1** | Load Balancer + WAF | `nginx:alpine` | 80, 443 | Proxy invers, balanceig Round-Robin i WAF | `extagram_front`<br>`extagram_services` | 172.20.0.2<br>172.19.0.7 |
| **S2** | PHP Backend 1 | `php:8.2-fpm-alpine` | 9000 | Execució lògica aplicació (Redundància) | `extagram_services`<br>`extagram_data` | 172.19.0.6<br>172.21.0.6 |
| **S3** | PHP Backend 2 | `php:8.2-fpm-alpine` | 9000 | Execució lògica aplicació (Redundància) | `extagram_services`<br>`extagram_data` | 172.19.0.4<br>172.21.0.4 |
| **S4** | Upload Service | `php:8.2-fpm-alpine` | 9000 | Gestió de pujada i eliminació d'arxius | `extagram_services`<br>`extagram_data` | 172.19.0.5<br>172.21.0.5 |
| **S5** | Image Server | `nginx:alpine` | 80 | Servir imatges pujades (read-only) | `extagram_services` | 172.19.0.3 |
| **S6** | Static Server | `nginx:alpine` | 80 | Servir CSS, SVG i favicon | `extagram_services` | 172.19.0.2 |
| **S7** | Database (Hardened) | `mysql:8.0` | 3306 | Emmagatzematge de posts i metadata | `extagram_data` (internal) | 172.21.0.2 |
| **S8** | LDAP Server | `osixia/openldap:1.5.0` | 389/636 | Autenticació d'usuaris (Hamza, Kevin) | `extagram_data` (internal) | 172.21.0.3 |

### Components de Seguretat (Sprint 4) - COMPLETAT

| Component | Tecnologia | Funció | Estat |
|-----------|------------|--------|-------|
| **WAF** | NGINX natiu + Regex Rules | Protecció SQL Injection, XSS, Path Traversal, Rate Limit | IMPLEMENTAT |
| **Hardening OS** | Docker security_opt, cap_drop, read_only | Contenidors immutables, mínim privilegi | IMPLEMENTAT |
| **Hardening MySQL** | Usuaris segurs, privilegis mínims | Base de dades fortificada | IMPLEMENTAT |
| **Firewall** | iptables | Protecció perimetral davant S1 | IMPLEMENTAT |

### Components de Monitoratge (Sprint 5) - PENDENT

| Component | Tecnologia | Port | Funció |
|-----------|------------|------|--------|
| **Grafana** | Grafana OSS | 3000 | Visualització de logs i mètriques |
| **Loki** | Grafana Loki | 3100 | Agregació i indexació de logs |
| **Promtail** | Promtail | 9080 | Recopilació de logs Docker |
| **Prometheus** | Prometheus | 9090 | Monitoratge de mètriques |

### Segmentació de Xarxa

El sistema implementa una arquitectura de **3 capes de xarxa** per maximitzar la seguretat:
```
extagram_front (172.20.0.x)
   └── S1: Load Balancer + WAF (exposat a Internet via port 80/443)

extagram_services (172.19.0.x)
   └── S1, S2, S3, S4, S5, S6 (comunicació interna aplicació)

extagram_data (172.21.0.x - INTERNAL)
   └── S2, S3, S4, S7, S8 (capa de dades aïllada del món exterior)

monitoring (172.22.0.x)
   └── Grafana, Loki, Promtail, Prometheus (observabilitat)
```

**Característiques de Seguretat:**
- S7 (MySQL) i S8 (LDAP) NO són accessibles des d'Internet
- S5 i S6 (servidors estàtics) NO poden accedir a la base de dades ni LDAP
- Només S2, S3, S4 (PHP amb lògica de negoci) tenen accés a S7 i S8
- Xarxa `extagram_data` configurada com `internal: true` (sense gateway)
- S1 NO pot accedir directament a S7 ni S8 (només S2/S3/S4 fan de pont)
- **WAF NGINX** en S1 bloqueja atacs abans d'arribar al backend
- **Firewall iptables** protegeix S1 de tràfic maliciós
- **Hardening contenidors**: `no-new-privileges`, `cap_drop: ALL`, `read_only` filesystem
- **Hardening MySQL**: Usuaris anònims eliminats, privilegis mínims

### Volums Persistents

| Volum | Servei | Funció | Mode |
|-------|--------|--------|------|
| **db_data** | S7 (MySQL) | Persistència de base de dades `extagram_db` | Read-Write |
| **uploads_data** | S4 (write)<br>S5 (read) | Emmagatzematge d'imatges pujades pels usuaris | S4: RW<br>S5: RO |
| **grafana-data** | Grafana | Persistència de dashboards i configuració | Read-Write |
| **prometheus-data** | Prometheus | Persistència de mètriques històriques | Read-Write |

### Flux de Peticions

#### 1. Petició de Visualització (GET /extagram.php)
```
Browser → Firewall (iptables) → S1 (nginx + WAF) → [S2 o S3] (PHP-FPM) → S7 (MySQL) + S8 (LDAP) → Resposta
                                       ↓
                                 WAF NGINX
                      (SQL Injection, XSS, Path Traversal)
                                       ↓
                              Balanceig Round-Robin
                               (50% S2, 50% S3)
```

#### 2. Petició de Pujada d'Imatge (POST /upload.php)
```
Browser → Firewall → S1 (WAF) → S4 (upload.php) → Guarda imatge → S7 (MySQL) → Redirect
                                         ↓
                                   uploads_data (Volume)
```

#### 3. Petició d'Arxius Estàtics (GET /style.css, /preview.svg)
```
Browser → Firewall → S1 → S6 (nginx static) → Resposta directa
```

#### 4. Petició d'Imatges Pujades (GET /uploads/img_xyz.jpg)
```
Browser → Firewall → S1 → S5 (nginx images) → Volume uploads_data (read-only) → Resposta
```

#### 5. Autenticació d'Usuaris (POST /login_ldap.php)
```
Browser → Firewall → S1 (WAF) → [S2 o S3] (login_ldap.php) → S8 (LDAP) → Validació → Resposta
```

#### 6. Monitoratge (Grafana)
```
Logs: Docker → Promtail → Loki → Grafana
Mètriques: Serveis → Prometheus → Grafana
```

---

## Proves de Segmentació de Xarxa

### Verificació de Connectivitat

El sistema implementa una **segmentació de xarxa en 3 capes** per garantir que només els serveis autoritzats puguin comunicar-se entre ells. A continuació es mostren les proves de connectivitat realitzades per validar l'aïllament correcte.

---

### Connexions Permeses - Capa de Dades

Els serveis PHP (S2, S3, S4) poden accedir a la capa de dades (S7, S8) perquè necessiten consultar la base de dades i autenticar usuaris via LDAP.

![Connexions Permeses - PHP a Base de Dades i LDAP](docs/imagenes/pruebas/conexion_permitida_1.png)

**Proves realitzades:**
- S2 → S7 (MySQL 172.21.0.2): CORRECTE - S2 executa consultes SQL
- S3 → S7 (MySQL 172.21.0.2): CORRECTE - S3 executa consultes SQL  
- S4 → S7 (MySQL 172.21.0.2): CORRECTE - S4 guarda metadata d'imatges
- S2 → S8 (LDAP 172.21.0.3): CORRECTE - S2 autentica usuaris
- S3 → S8 (LDAP 172.21.0.3): CORRECTE - S3 autentica usuaris

---

### Connexions Permeses - Load Balancer

El Load Balancer (S1) pot accedir a tots els serveis de la capa `extagram_services` per distribuir peticions HTTP.

![Connexions Permeses - Load Balancer a Serveis](docs/imagenes/pruebas/conexion_permitida_2.png)

**Proves realitzades:**
- S1 → S2 (PHP s2-php): CORRECTE - Balanceig Round-Robin
- S1 → S3 (PHP s3-php): CORRECTE - Balanceig Round-Robin
- S1 → S4 (Upload s4-upload): CORRECTE - Proxy de pujades
- S1 → S5 (Images s5-images): CORRECTE - Proxy d'imatges
- S1 → S6 (Static s6-static): CORRECTE - Proxy de CSS/SVG

---

### Connexions Bloquejades - Seguretat

Els servidors estàtics (S5, S6) NO poden accedir a la base de dades ni a LDAP, garantint que un compromís d'aquests serveis no exposi dades sensibles. Tampoc S1 (load balancer) pot accedir directament a la capa de dades.

![Connexions Bloquejades per Seguretat](docs/imagenes/pruebas/conexion_bloqueada.png)

**Proves realitzades:**
- S5 → S7 (MySQL 172.21.0.2): BLOQUEADO - S5 no necessita accés a BD
- S5 → S8 (LDAP 172.21.0.3): BLOQUEADO - S5 només serveix imatges
- S6 → S7 (MySQL 172.21.0.2): BLOQUEADO - S6 no necessita accés a BD
- S6 → S8 (LDAP 172.21.0.3): BLOQUEADO - S6 només serveix CSS/SVG
- S1 → S7 (MySQL s7-database): BLOQUEADO - S1 no accedeix directament a BD
- S1 → S8 (LDAP s8-ldap): BLOQUEADO - S1 no autentica, només fa proxy

---

### Comandes de Verificació

Aquestes són les comandes utilitzades per verificar la segmentació de xarxa:
```bash
# Connexions permeses (han de funcionar)
docker exec extagram-s2-php ping -c 2 -W 2 172.21.0.2       # S2 → S7
docker exec extagram-s3-php ping -c 2 -W 2 172.21.0.3       # S3 → S8
docker exec extagram-s4-upload ping -c 2 -W 2 172.21.0.2    # S4 → S7
docker exec extagram-s1-loadbalancer ping -c 2 -W 2 s2-php  # S1 → S2
docker exec extagram-s1-loadbalancer ping -c 2 -W 2 s6-static # S1 → S6

# Connexions bloquejades (han de fallar)
docker exec extagram-s5-images ping -c 2 -W 2 172.21.0.2    # S5 → S7
docker exec extagram-s6-static ping -c 2 -W 2 172.21.0.3    # S6 → S8
docker exec extagram-s1-loadbalancer ping -c 2 -W 2 s7-database  # S1 → S7
```

Per executar totes les proves automàticament:
```bash
cd ~/extagram-project/configuracions/docker
bash ../../proves/test_network_segmentation.sh
```

### Resultats de Seguretat

La segmentació de xarxa garanteix:
- **Cap servei estàtic** (S5, S6) pot accedir a dades sensibles
- **El load balancer** (S1) no pot saltar-se la lògica de negoci per accedir directament a BD
- **La capa de dades** (extagram_data) està completament aïllada d'Internet
- **Només els serveis PHP** (S2, S3, S4) fan de pont autoritzat entre capes
- **WAF NGINX** protegeix contra atacs web abans d'arribar al backend
- **Firewall iptables** filtra tràfic maliciós a nivell de sistema operatiu

---

## Tecnologies Utilitzades

### Stack Tecnològic Principal

| Component | Tecnologia | Versió | Ús al Projecte |
|-----------|------------|--------|----------------|
| **Containerització** | Docker | Latest | Orquestració de tots els serveis |
| **Orquestració** | Docker Compose | v2.x | Definició multi-contenidor |
| **Proxy Invers / LB** | NGINX | Alpine (Latest) | S1, S5, S6 |
| **WAF** | NGINX Native + Regex | Latest | S1 - Protecció web |
| **Firewall** | iptables | Latest | Protecció perimetral |
| **Backend** | PHP-FPM | 8.2-Alpine | S2, S3, S4 |
| **Base de Dades** | MySQL | 8.0 | S7 - Persistència |
| **Autenticació** | OpenLDAP | 1.5.0 | S8 - Gestió usuaris |
| **Monitoratge Logs** | Grafana + Loki | Latest | Centralització logs |
| **Monitoratge Mètriques** | Prometheus | Latest | Mètriques temps real |
| **Agregació Logs** | Promtail | Latest | Recopilació Docker logs |
| **Control de Versions** | Git + GitHub | - | Repositori central |
| **Gestió de Projecte** | ProofHub | - | Backlog, Kanban, Sprints |
| **Diagrames de Xarxa** | HTML/CSS/SVG | - | Diagrama interactiu |
| **Documentació** | Markdown | - | Tots els docs al repo |
| **Sistema Operatiu** | Ubuntu Server | 22.04 LTS | Sistema host |
| **Proves d'Estrès** | Apache Bench | 2.3 | Load testing |

---

## Planificació de Sprints

### Cronograma General

| Sprint | Data Inici | Data Fi | Durada | Objectiu Principal | Estat |
|--------|------------|---------|--------|-------------------|-------|
| **Sprint 0** | 08/12/2025 | 14/12/2025 | 1 setmana | Preparació i planificació inicial | COMPLETAT |
| **[Sprint 1](#sprint-1-mvp---màquina-única-completat)** | 15/12/2025 | 19/01/2026 | 5 setmanes | MVP en màquina única | COMPLETAT (19/01/2026) |
| **[Sprint 2](#sprint-2-dockerització-i-balanceig-completat)** | 20/01/2026 | 02/02/2026 | 2 setmanes | Dockerització, balanceig i segmentació | COMPLETAT (02/02/2026) |
| **[Sprint 3](#sprint-3-integració-i-proves-finals-completat)** | 03/02/2026 | 10/02/2026 | 1 setmana | Integració, proves i docs finals | COMPLETAT (10/02/2026) |
| **[Sprint 4](#sprint-4-seguretat-completat)** | 17/02/2026 | 23/02/2026 | 1 setmana | Seguretat (WAF, Hardening, Firewall) | COMPLETAT (23/02/2026) |
| **[Sprint 5](#sprint-5-monitoratge-pendent)** | 02/03/2026 | 10/03/2026 | 1 setmana | Monitoratge (Grafana, Loki, Prometheus) | PENDENT |
| **Presentació** | 16-17/03/2026 | - | 2 dies | Defensa del projecte | PENDENT |

---

### Sprint 1: MVP - Màquina Única [COMPLETAT]

**Documents del Sprint 1:**
- [Sprint 1 Planning](actes/sprint1/SPRINT1_PLANNING.md)
- [Sprint 1 Review](actes/sprint1/SPRINT1_REVIEW.md)

**Objectiu:** Servidor web funcional amb NGINX, PHP i MySQL en una sola màquina

**Dates:** 15 de Desembre de 2025 - 19 de Gener de 2026

#### Backlog del Sprint 1

| ID | Tasca | Assignat | Estimació | Prioritat | Estat |
|----|-------|----------|-----------|-----------|-------|
| T1.1 | Crear repositori GitHub amb estructura | Hamza | 2h | Alta | COMPLETAT |
| T1.2 | Configurar claus SSH per a GitHub | Hamza | 1h | Alta | COMPLETAT |
| T1.3 | Documentar anàlisi del projecte | Hamza | 4h | Alta | COMPLETAT |
| T1.4 | Instal·lar i configurar NGINX | Kevin | 3h | Alta | COMPLETAT |
| T1.5 | Configurar virtual host per Extagram | Kevin | 2h | Alta | COMPLETAT |
| T1.6 | Configurar PHP-FPM amb extensions | Hamza | 3h | Alta | COMPLETAT |
| T1.7 | Instal·lar i configurar MySQL Server | Hamza | 2h | Alta | COMPLETAT |
| T1.8 | Crear base de dades i taula posts | Hamza | 1h | Alta | COMPLETAT |
| T1.9 | Desplegar fitxers de l'aplicació | Kevin | 2h | Mitjana | COMPLETAT |
| T1.10 | Proves de funcionament complet | Tots | 3h | Alta | COMPLETAT |
| T1.11 | Documentar guia d'instal·lació | Hamza | 3h | Mitjana | COMPLETAT |
| T1.12 | Preparar Sprint Review i Demo | Tots | 2h | Mitjana | COMPLETAT |

**Total estimat:** 28 hores

#### Resultats Sprint 1

- **Objectiu assolit:** 100% de tasques completades
- **Demo exitosa:** Aplicació funcional demostrada al tutor el 19/01/2026
- **Retrospectiva:** Identificats punts de millora en comunicació

---

### Sprint 2: Dockerització i Balanceig [COMPLETAT]

**Documents del Sprint 2:**
- [Sprint 2 Planning](actes/sprint2/SPRINT2_PLANNING.md) 
- [Sprint 2 Review](actes/sprint2/SPRINT2_REVIEW.md) 

**Objectiu:** Segregar l'aplicació en contenidors Docker amb proxy invers, balanceig de càrrega i segmentació de xarxa

**Dates:** 20 de Gener de 2026 - 2 de Febrer de 2026

**Estat:** COMPLETAT (02/02/2026)

#### Backlog del Sprint 2

| ID | Tasca | Assignat | Estimació | Prioritat | Estat |
|----|-------|----------|-----------|-----------|-------|
| T2.1 | Crear Dockerfile per a S2/S3 (PHP-FPM extagram) | Hamza, Kevin | 2h | Alta | COMPLETAT |
| T2.2 | Crear Dockerfile per a S4 (PHP-FPM upload) | Hamza, Kevin | 1.5h | Alta | COMPLETAT |
| T2.3 | Crear imatge MySQL amb init.sql | Hamza, Kevin | 1h | Alta | COMPLETAT |
| T2.4 | Configurar NGINX S1 com a Load Balancer | Kevin | 3h | Alta | COMPLETAT |
| T2.5 | Crear configuració NGINX per a S5 (Images) | Kevin | 1h | Alta | COMPLETAT |
| T2.6 | Crear configuració NGINX per a S6 (Static) | Kevin | 1h | Alta | COMPLETAT |
| T2.7 | Crear docker-compose.yml complet | Hamza | 3h | Alta | COMPLETAT |
| T2.8 | Configurar segmentació de xarxa (3 capes) | Hamza, Kevin | 2h | Alta | COMPLETAT |
| T2.9 | Configurar volums persistents (DB i uploads) | Hamza | 1h | Alta | COMPLETAT |
| T2.10 | Implementar S8 OpenLDAP amb usuaris | Hamza | 2h | Alta | COMPLETAT |
| T2.11 | Proves de balanceig de càrrega Round-Robin | Hamza, Kevin | 2h | Alta | COMPLETAT |
| T2.12 | Proves de segmentació de xarxa | Hamza, Kevin | 2h | Alta | COMPLETAT |
| T2.13 | Documentar configuració Docker | Hamza | 2h | Mitjana | COMPLETAT |
| T2.14 | Crear diagrama interactiu HTML | Kevin | 3h | Mitjana | COMPLETAT |
| T2.15 | Preparar Sprint Review | Hamza, Kevin | 1h | Mitjana | COMPLETAT |

**Total estimat:** 28 hores

---

### Sprint 3: Integració i Proves Finals [COMPLETAT]

**Documents del Sprint 3:**
- [Sprint 3 Planning](actes/sprint3/SPRINT3_PLANNING.md)
- [Sprint 3 Review](actes/sprint3/SPRINT3_REVIEW.md)

**Objectiu:** Completar la integració, crear diagrama de xarxa i documentació final

**Dates:** 3 de Febrer de 2026 - 10 de Febrer de 2026

**Estat:** COMPLETAT (10/02/2026)

#### Backlog del Sprint 3

| ID | Tasca | Assignat | Estimació | Prioritat | Estat |
|----|-------|----------|-----------|-----------|-------|
| T3.1 | Crear esquema de xarxa amb Packet Tracer | Kevin | 3h | Alta | COMPLETAT |
| T3.2 | Documentar arquitectura de xarxa | Kevin | 2h | Alta | COMPLETAT |
| T3.3 | Proves de caiguda node S2 | Hamza | 1.5h | Alta | COMPLETAT |
| T3.4 | Proves de caiguda node S3 | Hamza | 1.5h | Alta | COMPLETAT |
| T3.5 | Proves de caiguda base de dades | Hamza | 2h | Alta | COMPLETAT |
| T3.6 | Documentar resultats de proves | Hamza | 2h | Alta | COMPLETAT |
| T3.7 | Revisar i completar README principal | Hamza | 3h | Alta | COMPLETAT |
| T3.8 | Preparar presentació final | Hamza | 2h | Alta | COMPLETAT |
| T3.9 | Revisar control de versions Git (commits) | Hamza | 1h | Mitjana | COMPLETAT |
| T3.10 | Proves finals integrades (tot el stack) | Tots | 2h | Alta | COMPLETAT |
| T3.11 | Sprint Review Final amb tutor | Tots | 2h | Alta | COMPLETAT |

**Total estimat:** 22 hores

#### Resultats Sprint 3

- **Objectiu assolit:** 100% de tasques completades
- **Proves de caiguda:** S2, S3 i S7 verificades amb èxit
- **Documentació:** README actualitzat, diagrames completats
- **Demo final:** Presentació exitosa al tutor el 10/02/2026

---

### Sprint 4: Seguretat [COMPLETAT]

**Documents del Sprint 4:**
- [Sprint 4 Planning](actes/sprint4/SPRINT4_PLANNING.md)
- [Sprint 4 Review](actes/sprint4/SPRINT4_REVIEW.md)

**Objectiu:** Implementar WAF, Hardening de sistema operatiu i base de dades, Firewall perimetral

**Dates:** 17 de Febrer de 2026 - 23 de Febrer de 2026

**Estat:** COMPLETAT (23/02/2026)

#### Backlog del Sprint 4

| ID | Tasca | Assignat | Estimació | Prioritat | Estat |
|----|-------|----------|-----------|-----------|-------|
| T4.1 | Implementar WAF NGINX natiu amb regex | Hamza | 4h | Alta | COMPLETAT |
| T4.2 | Configurar regles SQL Injection, XSS, Path Traversal | Hamza | 2h | Alta | COMPLETAT |
| T4.3 | Implementar Rate Limiting (10 req/s) | Hamza | 1h | Alta | COMPLETAT |
| T4.4 | Hardening contenidors (no-new-privileges, cap_drop) | Hamza | 3h | Alta | COMPLETAT |
| T4.5 | Hardening MySQL (usuaris mínims, privilegis restringits) | Hamza | 2h | Alta | COMPLETAT |
| T4.6 | Crear hardening.sql amb configuració segura | Hamza | 1h | Alta | COMPLETAT |
| T4.7 | Implementar firewall iptables davant S1 | Kevin | 3h | Alta | COMPLETAT |
| T4.8 | Proves de seguretat WAF (SQL, XSS, Path Traversal) | Hamza, Kevin | 2h | Alta | COMPLETAT |
| T4.9 | Documentar Sprint 4 Seguretat | Hamza | 2h | Mitjana | COMPLETAT |
| T4.10 | Sprint Review amb tutor | Tots | 1h | Mitjana | COMPLETAT |

**Total estimat:** 21 hores

#### Resultats Sprint 4

- **Objectiu assolit:** 100% de tasques completades
- **WAF NGINX**: Bloqueig SQL Injection, XSS, Path Traversal verificat
- **Hardening**: Contenidors amb `read_only`, `cap_drop: ALL`, MySQL fortificat
- **Firewall iptables**: Protecció perimetral implementada
- **Proves exitoses**: Tots els atacs bloquejats correctament
- **Demo final:** Presentació exitosa al tutor el 23/02/2026

**Mètriques de Seguretat:**

| Mètrica | Abans Sprint 4 | Després Sprint 4 | Millora |
|---------|----------------|------------------|---------|
| Atacs SQL Injection bloqueats | 0% | 100% | +100% |
| Atacs XSS bloqueats | 0% | 100% | +100% |
| Path Traversal bloqueats | 0% | 100% | +100% |
| Security Headers | 0/4 | 4/4 | +100% |
| Rate Limiting | No | Si (10 req/s) | Implementat |
| Contenidors hardened | 0/8 | 8/8 | +100% |
| MySQL fortificat | No | Si | Implementat |
| Firewall perimetral | No | iptables | Implementat |

---

### Sprint 5: Monitoratge [PENDENT]

**Objectiu:** Implementar sistema de monitoratge centralitzat amb Grafana, Loki i Prometheus

**Dates:** 2 de Març de 2026 - 10 de Març de 2026

**Estat:** PENDENT

#### Backlog del Sprint 5

| ID | Tasca | Assignat | Estimació | Prioritat | Estat |
|----|-------|----------|-----------|-----------|-------|
| T5.1 | Configurar Grafana + Loki per logs | Hamza | 3h | Alta | PENDENT |
| T5.2 | Configurar Promtail per recopilació logs Docker | Hamza | 2h | Alta | PENDENT |
| T5.3 | Configurar Prometheus per mètriques | Hamza | 2h | Alta | PENDENT |
| T5.4 | Crear Dashboard Logs en temps real | Hamza | 2h | Alta | PENDENT |
| T5.5 | Crear Dashboard Mètriques de Sistema | Hamza | 2h | Alta | PENDENT |
| T5.6 | Proves d'estrès amb Apache Bench (100, 500, 1000 req/s) | Kevin | 3h | Alta | PENDENT |
| T5.7 | Dashboard de rendiment aplicació | Hamza, Kevin | 2h | Alta | PENDENT |
| T5.8 | Configurar alertes automàtiques | Hamza | 2h | Mitjana | PENDENT |
| T5.9 | Documentar Sprint 5 Monitoratge | Hamza | 2h | Mitjana | PENDENT |
| T5.10 | Sprint Review final amb tutor | Tots | 1h | Mitjana | PENDENT |

**Total estimat:** 21 hores

#### Objectius del Sprint 5

- **Centralització de logs:** Grafana + Loki per visualització unificada
- **Monitoratge de mètriques:** Prometheus per CPU, RAM, requests/s, latència
- **Dashboard de rendiment:** Visualització temps real de l'aplicació
- **Proves d'estrès:** Apache Bench amb 100, 500, 1000 requests/s
- **Alertes:** Notificacions automàtiques davant anomalies

**Dashboards Grafana:**
1. **Logs en temps real** - Visualització de logs de tots els contenidors
2. **Mètriques de sistema** - CPU, RAM, Disc per contenidor
3. **Rendiment aplicació** - Requests/s, latència mitjana, errors HTTP
4. **Proves d'estrès** - Resultats comparatius de tests

---

### Gràfic de Progrés del Projecte
```
Progrés Global del Projecte

Sprint 1: [####################] 100% COMPLETAT
Sprint 2: [####################] 100% COMPLETAT
Sprint 3: [####################] 100% COMPLETAT
Sprint 4: [####################] 100% COMPLETAT
Sprint 5: [                    ]   0% PENDENT

Total:    [################    ]  80% (4/5 sprints)
```

---

## Guia d'Instal·lació Ràpida

### Pre-requisits

- **Sistema Operatiu:** Ubuntu Server 22.04 LTS
- **Docker:** 24.0.0 o superior
- **Docker Compose:** v2.20.0 o superior
- **Git:** 2.34.0 o superior
- **Memòria RAM:** Mínim 4GB (Recomanat 8GB)
- **Disc:** Mínim 20GB lliures

### Instal·lació Pas a Pas
```bash
# 1. Clonar el repositori
git clone https://github.com/HamzaTayibiITB2425/extagram-project.git
cd extagram-project/configuracions/docker

# 2. Crear arxiu .env amb les credencials
# IMPORTANT: Utilitzar contrasenyes fortes i úniques
# El fitxer .env està a .gitignore per seguretat
cp .env.example .env
nano .env

# 3. Aixecar els contenidors
docker compose up -d

# 4. Verificar que tot està UP
docker compose ps

# 5. Accedir a l'aplicació
# Navegador: https://extagram-grup3.duckdns.org
```

---

## Estructura del Repositori
```
extagram-project/
├── README.md                           # Aquest fitxer
├── .gitignore
├── LICENSE
│
├── actes/                              # Actes de reunions Scrum
│   ├── sprint1/
│   │   ├── SPRINT1_PLANNING.md
│   │   ├── SPRINT1_REVIEW.md
│   │   └── SPRINT1_RETROSPECTIVA.md
│   ├── sprint2/
│   │   ├── SPRINT2_PLANNING.md
│   │   ├── SPRINT2_REVIEW.md
│   │   └── SPRINT2_RETROSPECTIVA.md
│   ├── sprint3/
│   │   ├── SPRINT3_PLANNING.md
│   │   ├── SPRINT3_REVIEW.md
│   │   └── SPRINT3_RETROSPECTIVA.md
│   └── sprint4/
│       ├── SPRINT4_PLANNING.md
│       ├── SPRINT4_REVIEW.md
│       └── SPRINT4_RETROSPECTIVA.md
│
├── configuracions/
│   └── docker/
│       ├── docker-compose.yml          # Orquestració multi-contenidor
│       ├── .env.example
│       ├── s1-loadbalancer/
│       │   └── nginx.conf              # Config Load Balancer + WAF
│       ├── s2-php/
│       │   ├── Dockerfile
│       │   └── extagram.php
│       ├── s3-php/
│       │   ├── Dockerfile
│       │   └── extagram.php
│       ├── s4-upload/
│       │   ├── Dockerfile
│       │   ├── upload.php
│       │   ├── delete.php
│       │   └── recover.php
│       ├── s5-images/
│       │   └── nginx.conf
│       ├── s6-static/
│       │   └── nginx.conf
│       ├── s7-mysql/
│       │   ├── init.sql
│       │   └── hardening.sql           # Hardening MySQL
│       └── s8-ldap/
│           └── users.ldif
│
└── docs/                               # Documentació tècnica
    ├── imagenes/
    │   ├── arquitectura/
    │   └── pruebas/
    └── SPRINT4_SEGURIDAD.md
```

---

## Proves i Validació

### Proves de Funcionalitat

**Accés web HTTPS:**
```bash
curl -I https://extagram-grup3.duckdns.org/extagram.php
# Esperat: HTTP/2 200 OK
```

**Balanceig Round-Robin S2/S3:**
```bash
for i in {1..10}; do curl -s https://extagram-grup3.duckdns.org/extagram.php | grep "hostname"; done
# Esperat: Alternància entre s2-php i s3-php
```

**Upload d'imatges:**
```bash
curl -X POST -F "caption=Test" -F "photo=@test.jpg" https://extagram-grup3.duckdns.org/upload.php
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

**Contenidors amb read-only filesystem:**
```bash
docker exec extagram-s2-php touch /test.txt
# Esperat: Read-only file system
```

**MySQL usuari amb privilegis limitats:**
```bash
docker exec extagram-s7-database mysql -u extagram_admin -p -e "CREATE DATABASE hack;"
# Esperat: Access denied
```

---

## Documentació

### Actes de Sprints

- **Sprint 1:** [Planning](actes/sprint1/SPRINT1_PLANNING.md) • [Review](actes/sprint1/SPRINT1_REVIEW.md)
- **Sprint 2:** [Planning](actes/sprint2/SPRINT2_PLANNING.md) • [Review](actes/sprint2/SPRINT2_REVIEW.md)
- **Sprint 3:** [Planning](actes/sprint3/SPRINT3_PLANNING.md) • [Review](actes/sprint3/SPRINT3_REVIEW.md)
- **Sprint 4:** [Planning](actes/sprint4/SPRINT4_PLANNING.md) • [Review](actes/sprint4/SPRINT4_REVIEW.md) 

---

## Gestió de Riscos

| Risc | Probabilitat | Impacte | Mitigació | Estat |
|------|--------------|---------|-----------|-------|
| Caiguda d'un node PHP | Mitjana | Baix | Redundància S2+S3 | Mitigat |
| Sobrecàrrega de base de dades | Baixa | Alt | Pool de connexions, índexs | Monitoritzat |
| Atac SQL Injection | Mitjana | Crític | WAF + PDO prepared statements | Mitigat |
| Compromís contenidor | Mitjana | Alt | Hardening + read-only + cap_drop | Mitigat |
| Caiguda servidor complet | Baixa | Crític | Backups diaris + volums persistents | Implementat |

---

## Metodologia Agile

### Framework Utilitzat: Scrum

- **Sprints:** 1-2 setmanes (segons complexitat)
- **Daily Standups:** Cada dia a les 9:00 AM (15 min)
- **Sprint Planning:** Primer dia del sprint (2h)
- **Sprint Review:** Últim dia del sprint (1h)
- **Retrospectiva:** Després del Review (1h)

### Eines de Gestió

- **ProofHub:** Backlog, Kanban, Sprints, Time Tracking
- **GitHub Projects:** Issues, Pull Requests, Milestones
- **Google Meet:** Reunions virtuals dailies i reviews

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

## Contacte i Suport

### Equip del Projecte

**Hamza** (Product Owner / DevOps Lead)
- GitHub: [@HamzaTayibiITB2425](https://github.com/HamzaTayibiITB2425)
- Email: hamza.tayibi.7e6@itb.cat

**Kevin** (Infrastructure Engineer / Security)
- GitHub: [@KevinITB](https://github.com/KevinITB)
- Email: kevin.armada.7e4@itb.cat

### Tutor del Projecte

**Jordi Casas**
- Email: jordi.casas@itb.cat
- Institut Tecnològic de Barcelona

### Suport Tècnic

- **Issues GitHub:** [github.com/HamzaTayibiITB2425/extagram-project/issues](https://github.com/HamzaTayibiITB2425/extagram-project/issues)
- **Documentació:** [Llegeix els docs](docs/)
- **Wiki del Projecte:** [GitHub Wiki](https://github.com/HamzaTayibiITB2425/extagram-project/wiki)

---

## Llicència

Aquest projecte està sota llicència **MIT License**. Vegeu el fitxer [LICENSE](LICENSE) per més detalls.

Copyright © 2025-2026 Hamza, Kevin - Institut Tecnològic de Barcelona

---

## Agraïments

- **Jordi Casas** - Tutor del projecte per la seva guia i feedback continu
- **Institut Tecnològic de Barcelona** - Per proporcionar els recursos i infraestructura
- **Comunitat Docker** - Per l'excel·lent documentació i imatges oficials
- **NGINX Community** - Per les guies de configuració de proxy invers i WAF
- **Stack Overflow** - Per resoldre dubtes tècnics durant el desenvolupament

---

<div align="center">

**Projecte Extagram - Institut Tecnològic de Barcelona**  
**Equip:** Hamza, Kevin | **ASIX2c** | **2025-2026**

**SPRINT 4: COMPLETAT | SPRINT 5: PENDENT**

[![GitHub](https://img.shields.io/badge/GitHub-Repository-black?logo=github)](https://github.com/HamzaTayibiITB2425/extagram-project)
[![Docker](https://img.shields.io/badge/Docker-Containerized-2496ED?logo=docker)](https://www.docker.com/)
[![NGINX](https://img.shields.io/badge/NGINX-Load%20Balancer-009639?logo=nginx)](https://nginx.org/)

</div>

---

**Última actualització:** 24 de Febrer de 2026  
**Versió del Document:** 11.0  
**Estat del Projecte:** EN DESENVOLUPAMENT (80% completat)  
**Proper Sprint:** Sprint 5 (Monitoratge amb Grafana + Loki + Prometheus)  
**Data Presentació:** 16-17 de Març de 2026
