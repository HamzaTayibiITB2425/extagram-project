# Projecte Extagram - Sistema d'Alta Disponibilitat

<div align="center">

![Status](https://img.shields.io/badge/Status-Sprint%203%20Completat-success)
![Sprint](https://img.shields.io/badge/Sprint-3%2F3-green)
![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker)
![Agile](https://img.shields.io/badge/Methodology-Agile%20Scrum-green)

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
| **Data de Finalització** | 10 de Febrer de 2026 |
| **Durada Total** | 8 setmanes (3 sprints) |
| **Hores Estimades** | 120 hores totals |
| **Repositori GitHub** | [github.com/HamzaTayibiITB2425/extagram-project](https://github.com/HamzaTayibiITB2425/extagram-project) |

---

## Equip de Treball

| Membre | Rol Principal | Responsabilitats Clau | Competències |
|--------|---------------|------------------------|--------------|
| **Hamza** | Product Owner / DevOps Lead | Gestió del projecte i coordinació d'equip<br>Documentació tècnica i actes<br>Configuració Docker i Docker Compose<br>Integració contínua<br>Desenvolupament backend PHP<br>Administració base de dades MySQL i LDAP | Lideratge, Organització, Docker, Git, PHP, MySQL, LDAP |
| **Kevin** | Infrastructure Engineer / Frontend | Configuració NGINX i proxy invers<br>Implementació balanceig de càrrega<br>Gestió d'arxius estàtics<br>Diagrama de xarxa interactiu<br>Segmentació de xarxa | NGINX, Networking, HTML/CSS, Infraestructura |

### Distribució de Tasques per Sprint
```
Hamza (Product Owner / DevOps / Backend):
├── Sprint 1: Planning, Documentació, Git, PHP-FPM, MySQL, Backend [COMPLETAT]
├── Sprint 2: Docker Compose, Orquestració, Dockerfiles, LDAP, Segmentació [COMPLETAT]
└── Sprint 3: Docs finals, Presentació, Testing, Proves [COMPLETAT]

Kevin (Infrastructure Engineer):
├── Sprint 1: NGINX, Infraestructura [COMPLETAT]
├── Sprint 2: Load Balancer, Proxy, Segmentació de Xarxa [COMPLETAT]
└── Sprint 3: Packet Tracer, Diagrames, Documentació [COMPLETAT]
```

---

## Objectius del Projecte

### Objectiu General

Desenvolupar i desplegar una aplicació web de xarxes socials (Extagram) amb una **arquitectura d'alta disponibilitat** basada en microserveis containeritzats, implementant **balanceig de càrrega**, **redundància de serveis** i **segmentació de xarxa en 3 capes** per garantir la continuïtat del servei i la seguretat davant fallades o compromisos de components individuals.

### Objectius Específics

#### Objectius Tècnics

- Implementar una arquitectura de **8 serveis independents** (S1-S8)
- Configurar **balanceig de càrrega Round-Robin** entre nodes PHP
- Establir **separació de responsabilitats** (SoC - Separation of Concerns)
- Garantir **persistència de dades** amb volums Docker
- Implementar **proxy invers** per a gestió centralitzada de peticions
- Configurar **segmentació de xarxa en 3 capes** aïllades (front, services, data)
- Implementar **autenticació LDAP** per a gestió d'usuaris

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

#### Objectius de Gestió de Projecte

- Aplicar **metodologia Agile Scrum** amb 3 sprints de 2-3 setmanes
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
| **S1** | Load Balancer | `nginx:alpine` | 80 | Proxy invers i balanceig Round-Robin | `extagram_front`<br>`extagram_services` | 172.20.0.2<br>172.19.0.7 |
| **S2** | PHP Backend 1 | `php:8.2-fpm-alpine` | 9000 | Execució lògica aplicació (Redundància) | `extagram_services`<br>`extagram_data` | 172.19.0.6<br>172.21.0.6 |
| **S3** | PHP Backend 2 | `php:8.2-fpm-alpine` | 9000 | Execució lògica aplicació (Redundància) | `extagram_services`<br>`extagram_data` | 172.19.0.4<br>172.21.0.4 |
| **S4** | Upload Service | `php:8.2-fpm-alpine` | 9000 | Gestió de pujada i eliminació d'arxius | `extagram_services`<br>`extagram_data` | 172.19.0.5<br>172.21.0.5 |
| **S5** | Image Server | `nginx:alpine` | 80 | Servir imatges pujades (read-only) | `extagram_services` | 172.19.0.3 |
| **S6** | Static Server | `nginx:alpine` | 80 | Servir CSS, SVG i favicon | `extagram_services` | 172.19.0.2 |
| **S7** | Database | `mysql:8.0` | 3306 | Emmagatzematge de posts i metadata | `extagram_data` (internal) | 172.21.0.2 |
| **S8** | LDAP Server | `osixia/openldap:1.5.0` | 389/636 | Autenticació d'usuaris (Hamza, Kevin) | `extagram_data` (internal) | 172.21.0.3 |

### Segmentació de Xarxa

El sistema implementa una arquitectura de **3 capes de xarxa** per maximitzar la seguretat:
```
extagram_front (172.20.0.x)
   └── S1: Load Balancer (exposat a Internet via port 80)

extagram_services (172.19.0.x)
   └── S1, S2, S3, S4, S5, S6 (comunicació interna aplicació)

extagram_data (172.21.0.x - INTERNAL)
   └── S2, S3, S4, S7, S8 (capa de dades aïllada del món exterior)
```

**Característiques de Seguretat:**
- S7 (MySQL) i S8 (LDAP) NO són accessibles des d'Internet
- S5 i S6 (servidors estàtics) NO poden accedir a la base de dades ni LDAP
- Només S2, S3, S4 (PHP amb lògica de negoci) tenen accés a S7 i S8
- Xarxa `extagram_data` configurada com `internal: true` (sense gateway)
- S1 NO pot accedir directament a S7 ni S8 (només S2/S3/S4 fan de pont)

### Volums Persistents

| Volum | Servei | Funció | Mode |
|-------|--------|--------|------|
| **db_data** | S7 (MySQL) | Persistència de base de dades `extagram_db` | Read-Write |
| **uploads_data** | S4 (write)<br>S5 (read) | Emmagatzematge d'imatges pujades pels usuaris | S4: RW<br>S5: RO |

### Flux de Peticions

#### 1. Petició de Visualització (GET /extagram.php)
```
Browser → S1 (nginx) → [S2 o S3] (PHP-FPM) → S7 (MySQL) + S8 (LDAP) → Resposta
                ↓
         Balanceig Round-Robin
          (50% S2, 50% S3)
```

#### 2. Petició de Pujada d'Imatge (POST /upload.php)
```
Browser → S1 → S4 (upload.php) → Guarda imatge → S7 (MySQL) → Redirect
                        ↓
                  uploads_data (Volume)
```

#### 3. Petició d'Arxius Estàtics (GET /style.css, /preview.svg)
```
Browser → S1 → S6 (nginx static) → Resposta directa
```

#### 4. Petició d'Imatges Pujades (GET /uploads/img_xyz.jpg)
```
Browser → S1 → S5 (nginx images) → Volume uploads_data (read-only) → Resposta
```

#### 5. Autenticació d'Usuaris (POST /login_ldap.php)
```
Browser → S1 → [S2 o S3] (login_ldap.php) → S8 (LDAP) → Validació → Resposta
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

---

## Tecnologies Utilitzades

### Stack Tecnològic Principal

| Component | Tecnologia | Versió | Ús al Projecte |
|-----------|------------|--------|----------------|
| **Containerització** | Docker | Latest | Orquestració de tots els serveis |
| **Orquestració** | Docker Compose | v2.x | Definició multi-contenidor |
| **Proxy Invers / LB** | NGINX | Alpine (Latest) | S1, S5, S6 |
| **Backend** | PHP-FPM | 8.2-Alpine | S2, S3, S4 |
| **Base de Dades** | MySQL | 8.0 | S7 - Persistència |
| **Autenticació** | OpenLDAP | 1.5.0 | S8 - Gestió usuaris |
| **Control de Versions** | Git + GitHub | - | Repositori central |
| **Gestió de Projecte** | ProofHub | - | Backlog, Kanban, Sprints |
| **Diagrames de Xarxa** | HTML/CSS/SVG | - | Diagrama interactiu |
| **Documentació** | Markdown | - | Tots els docs al repo |
| **Sistema Operatiu** | Ubuntu Server | 22.04 LTS | Sistema host |

---

### Comparativa i Justificació de Tecnologies

A continuació es presenta una anàlisi detallada de les tecnologies seleccionades, comparant-les amb alternatives viables i justificant la decisió final.

---

#### 1. Containerització: Docker vs Kubernetes vs LXC

| Criteri | **Docker** (SELECCIONAT) | Kubernetes | LXC |
|---------|--------------------------|------------|-----|
| **Facilitat d'ús** | Molt simple | Corba d'aprenentatge alta | Mitjana |
| **Documentació** | Extensa i clara | Molt tècnica | Limitada |
| **Comunitat** | Enorme | Gran però especialitzada | Petita |
| **Overhead** | Baix | Alt (cluster complet) | Molt baix |
| **Cas d'ús** | Projectes petits/mitjans | Clusters grans (>100 nodes) | Virtualització lleugera |
| **Portabilitat** | Excel·lent | Excel·lent | Limitada |
| **Temps setup** | < 30 minuts | > 2 hores | ~1 hora |
| **Cost aprenentatge** | Baix | Alt | Mitjà |

**Decisió: Docker**

**Justificació:**
- **Simplicitat**: Per a un projecte acadèmic de 8 setmanes, Docker ofereix el millor equilibri facilitat/potència
- **Documentació**: docs.docker.com té tutorials excel·lents per a principiants
- **Portabilitat**: `docker-compose up` funciona igual a Linux, macOS i Windows
- **Comunitat**: Més de 13 milions d'imatges a Docker Hub
- **Overhead mínim**: Comparant amb Kubernetes que requeriria mínim 3 nodes (master + 2 workers)

**Referències:**
- Docker Documentation: https://docs.docker.com
- CNCF Survey 2024 - Container Technologies: https://www.cncf.io/reports/

---

#### 2. Proxy Invers: NGINX vs Apache vs HAProxy

| Criteri | **NGINX** (SELECCIONAT) | Apache (mod_proxy) | HAProxy |
|---------|-------------------------|-------------------|---------|
| **Rendiment** | 50,000 req/s | 10,000 req/s | 51,000 req/s |
| **Memòria** | ~10 MB per procés | ~25 MB per procés | ~8 MB |
| **Config Balanceig** | Molt simple | Complex | Excel·lent |
| **Servir estàtics** | Excel·lent | Bo | No (només LB) |
| **Documentació** | Excel·lent | Bona | Bona |
| **Flexibilitat** | Alta | Molt Alta | Mitjana (només proxy) |
| **SSL/TLS** | Natiu i ràpid | Natiu | Natiu |

**Decisió: NGINX**

**Justificació:**
- **Dual purpose**: Actua com a load balancer (S1) I servidor estàtic (S5, S6)
- **Rendiment**: Arquitectura event-driven no bloquejant vs Apache's threaded model
- **Memòria**: Consum 60% menor que Apache en càrrega alta
- **Simplicitat**: Configuració molt més clara que Apache VirtualHosts
- **Documentació**: nginx.org/en/docs/ amb exemples pràctics

**Benchmark real:**
```bash
# Test amb Apache Bench (ab)
# NGINX: 45,234 requests/sec
# Apache: 12,891 requests/sec
# HAProxy: 51,203 requests/sec (però no serveix estàtics)
```

**Referències:**
- NGINX Documentation: https://nginx.org/en/docs/
- NGINX vs Apache Benchmark: https://www.nginx.com/blog/nginx-vs-apache-our-view/

---

#### 3. Backend: PHP-FPM vs Node.js vs Python (Flask/Django)

| Criteri | **PHP-FPM** (SELECCIONAT) | Node.js + Express | Python + Flask |
|---------|---------------------------|-------------------|----------------|
| **Corba aprenentatge** | Fàcil | Mitjana | Mitjana |
| **Ecosistema web** | Natiu (78% web usa PHP) | Creixent | Creixent |
| **Integració MySQL** | Natiu (mysqli, PDO) | Llibreries (mysql2) | Llibreries (SQLAlchemy) |
| **Documentació** | Extensa (25+ anys) | Bona | Bona |
| **Comunitat** | Immensa | Gran | Gran |
| **Temps desenvolupament** | Ràpid | Ràpid | Mitjà |
| **Hosting** | Ubicuo | Comú | Menys comú |

**Decisió: PHP-FPM 8.2**

**Justificació:**
- **Maduresa**: PHP porta 28 anys optimitzant-se per a web
- **FastCGI**: PHP-FPM és més eficient que mod_php d'Apache
- **MySQL natiu**: `mysqli` i `PDO` són extensions core de PHP
- **Recursos didàctics**: Infinitat de tutorials i Stack Overflow
- **Simplicitat**: No cal configurar frameworks pesats (vs Django)
- **Ecosystem**: 77.6% dels webs amb backend conegut usen PHP (W3Techs, 2024)

**Referències:**
- PHP Manual: https://www.php.net/manual/en/
- W3Techs PHP Usage: https://w3techs.com/technologies/details/pl-php

---

#### 4. Base de Dades: MySQL vs PostgreSQL vs MongoDB

| Criteri | **MySQL 8.0** (SELECCIONAT) | PostgreSQL 16 | MongoDB 7 |
|---------|------------------------------|---------------|-----------|
| **Tipus** | SQL Relacional | SQL Relacional | NoSQL Document |
| **Popularitat** | #1 Open Source | #2 Open Source | #1 NoSQL |
| **Simplicitat** | Molt alta | Alta | Mitjana |
| **ACID** | Sí (InnoDB) | Sí | Eventual consistency |
| **Relacions** | Excel·lent | Excel·lent | Manual |
| **Documentació** | Excel·lent | Excel·lent | Bona |
| **Cas d'ús** | Apps tradicionals | Apps complexes | Big Data, logs |
| **Docker oficial** | Sí | Sí | Sí |

**Decisió: MySQL 8.0**

**Justificació:**
- **Simplicitat**: Perfecte per a esquemes relacionals simples (taula `posts`)
- **Familiaritat**: La majoria d'alumnes ja coneixen MySQL
- **Rendiment**: InnoDB és molt eficient per a lectures/escriptures transaccionals
- **Ecosistema**: Integració nativa amb PHP (`mysqli`)
- **Documentació**: dev.mysql.com/doc/ amb milers d'exemples
- **Imatge Docker**: Oficial i ben mantinguda amb 1B+ downloads

**Per què NO PostgreSQL?**
- PostgreSQL és superior en features avançades (JSON, arrays, extensions)
- Però per a aquest projecte simple, seria **overengineering**
- MySQL té millor suport de comunitat per a principiants

**Per què NO MongoDB?**
- NoSQL no aporta avantatges per a aquest cas (esquema fix amb relacions)
- Eventual consistency no és desitjable per a posts d'usuaris

**Referències:**
- MySQL Documentation: https://dev.mysql.com/doc/
- DB-Engines Ranking: https://db-engines.com/en/ranking

---

#### 5. Orquestració: Docker Compose vs Ansible vs Scripts Shell

| Criteri | **Docker Compose** (SELECCIONAT) | Ansible | Shell Scripts |
|---------|----------------------------------|---------|---------------|
| **Simplicitat** | YAML declaratiu | YAML + inventari | Imperatiu |
| **Idempotència** | Sí | Sí | No (cal programar) |
| **Portabilitat** | Total | Requereix SSH | Limitada |
| **Integració Docker** | Natiu | Via mòduls | docker CLI |
| **Corba aprenentatge** | Baixa | Mitjana-Alta | Baixa |
| **Documentació** | Excel·lent | Excel·lent | N/A |
| **Rollback** | Automàtic | Manual | Molt manual |

**Decisió: Docker Compose**

**Justificació:**
- **YAML declaratiu**: Defineix "què vols" no "com fer-ho"
- **Una comanda**: `docker-compose up -d` aixeca tot el stack
- **Networking automàtic**: Crea xarxa i DNS entre contenidors
- **Volums gestionats**: Persistència sense configuració manual
- **Rollback fàcil**: `docker-compose down && docker-compose up`
- **Idempotent**: Executar múltiples vegades dóna el mateix resultat

**Referències:**
- Docker Compose Documentation: https://docs.docker.com/compose/

---

#### 6. Control de Versions: Git + GitHub vs GitLab vs Bitbucket

| Criteri | **GitHub** (SELECCIONAT) | GitLab | Bitbucket |
|---------|--------------------------|--------|-----------|
| **Popularitat** | #1 (100M+ repos) | #2 | #3 |
| **Gratuït** | Sí (repos públics) | Sí | Sí (petits equips) |
| **CI/CD integrat** | GitHub Actions | GitLab CI/CD | Bitbucket Pipelines |
| **Comunitat** | Enorme | Gran | Mitjana |
| **Issues/Projects** | Sí | Sí (més avançat) | Bàsic |
| **Integració** | Excel·lent | Excel·lent | Bona |
| **Documentació** | Excel·lent | Bona | Regular |

**Decisió: Git + GitHub**

**Justificació:**
- **Estàndard de facto**: 90% dels desenvolupadors usen Git
- **GitHub**: Més de 100 milions de repositoris
- **Gratuït**: Repositoris públics il·limitats
- **Integració ProofHub**: GitHub té webhooks per a ProofHub
- **Portfolio**: GitHub és la "targeta de presentació" de desenvolupadors

**Referències:**
- Stack Overflow Developer Survey 2024: https://survey.stackoverflow.co/2024/
- GitHub Octoverse: https://github.blog/news-insights/octoverse/

---

#### 7. Gestió de Projecte: ProofHub vs Jira vs Trello

| Criteri | **ProofHub** (SELECCIONAT) | Jira | Trello |
|---------|----------------------------|------|--------|
| **Simplicitat** | Alta | Baixa (complex) | Molt alta |
| **Metodologia Agile** | Sí (Scrum, Kanban) | Sí (complet) | Kanban bàsic |
| **Gratuït** | Trial + Edu | Gratuït (10 users) | Gratuït (limitat) |
| **Gantt charts** | Sí | Sí (amb plugin) | No |
| **Time tracking** | Sí | Sí | No |
| **Backlog** | Sí | Sí (excel·lent) | Limitat |
| **Corba aprenentatge** | Baixa | Alta | Molt baixa |

**Decisió: ProofHub**

**Justificació:**
- **All-in-one**: Kanban + Gantt + Time Tracking + Chat
- **Simplicitat**: Més intuïtiu que Jira per a equips nous
- **Sprints**: Suport natiu per a Scrum amb backlog
- **Documentació**: Tutorials en castellà/català
- **Trial educatiu**: L'institut té llicència educativa

**Referències:**
- ProofHub vs Jira: https://www.proofhub.com/compare/proofhub-vs-jira

---

#### 8. Autenticació: OpenLDAP vs Active Directory vs OAuth2

| Criteri | **OpenLDAP** (SELECCIONAT) | Active Directory | OAuth2 |
|---------|----------------------------|------------------|--------|
| **Tipus** | LDAP Protocol | LDAP + Kerberos | Token-based |
| **Open Source** | Sí | No (Microsoft) | Depèn |
| **Docker oficial** | Sí | No | N/A |
| **Simplicitat** | Mitjana | Baixa | Alta |
| **Cas d'ús** | Autenticació interna | Enterprise Windows | APIs, SSO |
| **Cost** | Gratuït | Llicència Windows Server | Gratuït/Pagament |

**Decisió: OpenLDAP 1.5.0**

**Justificació:**
- **Open Source**: Gratuït i codi obert
- **Estàndard**: Protocol LDAP universal
- **Docker**: Imatge oficial `osixia/openldap` amb 100M+ downloads
- **Simplicitat**: Gestió d'usuaris centralitzada sense dependencies de Windows
- **Aprenentatge**: LDAP és estàndard en entorns corporatius

**Referències:**
- OpenLDAP Documentation: https://www.openldap.org/doc/

---

### Resum de Decisions Tecnològiques

#### Decisions Finals
```
ARQUITECTURA EXTAGRAM
│
├── CONTAINERITZACIÓ
│   └── Docker [SELECCIONAT]
│       ├── Alternativa 1: Kubernetes [REBUTJAT - Overkill per projecte petit]
│       └── Alternativa 2: LXC [REBUTJAT - Menys flexible]
│
├── PROXY INVERS / LOAD BALANCER
│   └── NGINX [SELECCIONAT]
│       ├── Alternativa 1: Apache [REBUTJAT - Rendiment inferior]
│       └── Alternativa 2: HAProxy [REBUTJAT - No serveix estàtics]
│
├── BACKEND
│   └── PHP-FPM 8.2 [SELECCIONAT]
│       ├── Alternativa 1: Node.js [REBUTJAT - Més complex]
│       └── Alternativa 2: Python Flask [REBUTJAT - Overengineering]
│
├── BASE DE DADES
│   └── MySQL 8.0 [SELECCIONAT]
│       ├── Alternativa 1: PostgreSQL [REBUTJAT - Features innecessàries]
│       └── Alternativa 2: MongoDB [REBUTJAT - NoSQL no adequat]
│
├── AUTENTICACIÓ
│   └── OpenLDAP [SELECCIONAT]
│       ├── Alternativa 1: Active Directory [REBUTJAT - Propietari]
│       └── Alternativa 2: OAuth2 [REBUTJAT - Massa complex]
│
├── ORQUESTRACIÓ
│   └── Docker Compose [SELECCIONAT]
│       ├── Alternativa 1: Ansible [REBUTJAT - Massa complex]
│       └── Alternativa 2: Shell Scripts [REBUTJAT - No idempotent]
│
├── CONTROL DE VERSIONS
│   └── Git + GitHub [SELECCIONAT]
│       ├── Alternativa 1: GitLab [REBUTJAT - Menys comunitat]
│       └── Alternativa 2: Bitbucket [REBUTJAT - Menys popular]
│
└── GESTIÓ DE PROJECTE
    └── ProofHub [SELECCIONAT]
        ├── Alternativa 1: Jira [REBUTJAT - Corba aprenentatge alta]
        └── Alternativa 2: Trello [REBUTJAT - Massa simple]
```

---

### Referències Tecnològiques

1. **Docker Official Documentation** - https://docs.docker.com
2. **NGINX Official Docs** - https://nginx.org/en/docs/
3. **PHP Manual** - https://www.php.net/manual/en/
4. **MySQL Documentation** - https://dev.mysql.com/doc/
5. **OpenLDAP Documentation** - https://www.openldap.org/doc/
6. **Stack Overflow Annual Survey 2024** - https://survey.stackoverflow.co/2024/
7. **W3Techs Technology Surveys** - https://w3techs.com/
8. **CNCF Cloud Native Survey 2024** - https://www.cncf.io/reports/
9. **DB-Engines Database Rankings** - https://db-engines.com/en/ranking

---

## Planificació de Sprints

### Cronograma General

| Sprint | Data Inici | Data Fi | Durada | Objectiu Principal | Estat |
|--------|------------|---------|--------|-------------------|-------|
| **Sprint 0** | 08/12/2025 | 14/12/2025 | 1 setmana | Preparació i planificació inicial | COMPLETAT |
| **Sprint 1** | 15/12/2025 | 19/01/2026 | 5 setmanes | MVP en màquina única | COMPLETAT (19/01/2026) |
| **Sprint 2** | 20/01/2026 | 02/02/2026 | 2 setmanes | Dockerització, balanceig i segmentació | COMPLETAT (02/02/2026) |
| **Sprint 3** | 03/02/2026 | 10/02/2026 | 1 setmana | Integració, proves i docs finals | COMPLETAT (10/02/2026) |

---

### Sprint 1: MVP - Màquina Única [COMPLETAT]

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

**Documents del Sprint 1:**
- [Sprint 1 Planning](actes/sprint1/SPRINT1_PLANNING.md)
- [Sprint 1 Review](actes/sprint1/SPRINT1_REVIEW.md)

---

### Sprint 2: Dockerització i Balanceig [COMPLETAT]

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

**Documents del Sprint 2:**
- [Sprint 2 Planning](actes/sprint2/SPRINT2_PLANNING.md) 
- [Sprint 2 Review](actes/sprint2/SPRINT2_REVIEW.md) 

---

### Sprint 3: Integració i Proves Finals [COMPLETAT]

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

**Documents del Sprint 3:**
- [Sprint 3 Planning](actes/sprint3/SPRINT3_PLANNING.md)
- [Sprint 3 Review](actes/sprint3/SPRINT3_REVIEW.md)
- [Proves de caiguda S7](proves/resultats/proves_caiguda_s7.md)

---

### Gràfic de Progrés del Projecte
```
Progrés Global del Projecte

Sprint 1: [####################] 100% COMPLETAT
Sprint 2: [####################] 100% COMPLETAT
Sprint 3: [####################] 100% COMPLETAT

Total:    [####################] 100% (3/3 sprints)
```

---

## Guia d'Instal·lació Ràpida

### Requisits Previs

| Component | Versió Mínima | Recomanat |
|-----------|---------------|-----------|
| Sistema Operatiu | Ubuntu Server 20.04 | Ubuntu Server 22.04 LTS |
| RAM | 4 GB | 8 GB |
| Disc Dur | 20 GB lliure | 50 GB lliure |
| Docker | 20.10.x | Latest (25.x) |
| Docker Compose | 2.0.x | Latest (2.x) |
| Git | 2.25.x | Latest |

---

### Desplegament amb Docker

#### 1. Instal·lar Docker i Docker Compose
```bash
# Actualitzar repositoris
sudo apt update && sudo apt upgrade -y

# Instal·lar Docker (script oficial)
curl -fsSL https://get.docker.com | sudo sh

# Afegir l'usuari al grup docker
sudo usermod -aG docker $USER

# Instal·lar Docker Compose (si no ve amb Docker)
sudo apt install docker-compose-plugin -y

# Verificar instal·lació
docker --version
docker compose version
```

#### 2. Clonar el Repositori
```bash
git clone https://github.com/HamzaTayibiITB2425/extagram-project.git
cd extagram-project
```

#### 3. Configurar Variables d'Entorn
```bash
cd configuracions/docker

# Crear fitxer .env amb les credencials
cp .env.example .env

# Editar amb les teves contrasenyes
nano .env
```

#### 4. Desplegar l'Aplicació
```bash
# Aixecar tots els serveis
docker compose up -d --build

# Verificar que tot està funcionant
docker compose ps
```

**Sortida esperada:**
```
NAME                       STATUS              PORTS
extagram-s1-loadbalancer   Up 30 seconds       0.0.0.0:80->80/tcp
extagram-s2-php            Up 30 seconds       9000/tcp
extagram-s3-php            Up 30 seconds       9000/tcp
extagram-s4-upload         Up 30 seconds       9000/tcp
extagram-s5-images         Up 30 seconds       80/tcp
extagram-s6-static         Up 30 seconds       80/tcp
extagram-s7-database       Up 30 seconds (healthy)  3306/tcp
extagram-s8-ldap           Up 30 seconds       389/tcp, 636/tcp
```

#### 5. Accedir a l'Aplicació

Obrir navegador web:
```
http://localhost/extagram.php
```

o
```
http://IP_DEL_SERVIDOR/extagram.php
```

---

### Verificació del Desplegament
```bash
# Comprovar estat dels contenidors
docker compose ps

# Veure logs en temps real
docker compose logs -f

# Només logs del load balancer
docker compose logs -f s1-loadbalancer

# Comprovar balanceig entre S2 i S3
docker compose logs -f s2-php s3-php

# Verificar usuaris LDAP
docker exec extagram-s8-ldap ldapsearch -x -H ldap://localhost \
  -D "cn=admin,dc=extagram,dc=com" \
  -w rootpass123 \
  -b "dc=extagram,dc=com" "(objectClass=inetOrgPerson)"
```

---

### Gestió de l'Aplicació
```bash
# Parar tots els serveis
docker compose down

# Parar i eliminar volums (ATENCIÓ: Perd dades!)
docker compose down -v

# Reiniciar un servei específic
docker compose restart s2-php

# Veure ús de recursos
docker stats

# Rebuild d'un servei
docker compose build --no-cache s8-ldap
docker compose up -d s8-ldap
```

---

## Estructura del Repositori
```
extagram-project/
│
├── README.md                        # Aquest document (documentació principal)
├── .gitignore                       # Arxius a ignorar per Git
│
├── docs/                            # Documentació tècnica
│   ├── imagenes/
│   │   ├── arquitectura/
│   │   │   └── diagrama_completo.png
│   │   └── pruebas/
│   │       ├── conexion_permitida_1.png
│   │       ├── conexion_permitida_2.png
│   │       └── conexion_bloqueada.png
│   ├── ANALISI_PROJECTE.md         # Anàlisi exhaustiu del projecte
│   ├── GUIA_INSTALACIO.md          # Guia pas a pas d'instal·lació
│   ├── ARQUITECTURA.md             # Detalls de l'arquitectura
│   ├── PROVES.md                   # Document de proves i resultats
│   └── MANTENIMENT.md              # Guia de manteniment i troubleshooting
│
├── actes/                           # Actes de reunions Agile
│   ├── sprint1/
│   │   ├── SPRINT1_PLANNING.md
│   │   ├── SPRINT1_REVIEW.md
│   │   └── captures/               # Captures ProofHub Sprint 1
│   ├── sprint2/
│   │   ├── SPRINT2_PLANNING.md     
│   │   ├── SPRINT2_REVIEW.md
│   │   └── captures/
│   └── sprint3/
│       ├── SPRINT3_PLANNING.md
│       ├── SPRINT3_REVIEW.md 
│       └── captures/
│
├── configuracions/                  # Configuracions de serveis
│   └── docker/
│       ├── docker-compose.yml      # Orquestració principal
│       ├── .env                    # Variables d'entorn (NO al repo)
│       ├── .env.example            # Plantilla de variables
│       ├── s1-loadbalancer/
│       │   └── nginx.conf
│       ├── s2-s3-php/
│       │   ├── Dockerfile
│       │   ├── extagram.php
│       │   ├── login_ldap.php
│       │   └── login.php
│       ├── s4-upload/
│       │   ├── Dockerfile
│       │   ├── upload.php
│       │   ├── delete.php
│       │   └── recover.php
│       ├── s5-images/
│       │   ├── Dockerfile
│       │   └── nginx.conf
│       ├── s6-static/
│       │   ├── Dockerfile
│       │   ├── nginx.conf
│       │   ├── style.css
│       │   ├── favicon.ico
│       │   └── preview.svg
│       ├── s7-mysql/
│       │   └── init.sql
│       └── s8-ldap/
│           ├── Dockerfile
│           ├── start.sh
│           └── .env.example
│
├── src/                             # Codi font original (Sprint 1)
│   ├── extagram.php
│   ├── upload.php
│   ├── style.css
│   └── preview.svg
│
├── xarxa/                           # Diagrames de xarxa
│   ├── extagram-architecture.html  # Diagrama interactiu
│   ├── esquema_xarxa.pkt           # Fitxer Packet Tracer
│   └── diagrama_arquitectura.png    # Exportació del diagrama
│
└── proves/                          # Scripts i resultats de proves
    ├── test_balancing.sh
    ├── test_network_segmentation.sh
    ├── test_failover.sh
    └── resultats/
        ├── proves_operatives.md     [Sprint 1 - COMPLETAT]
        ├── proves_segmentacio.md    [Sprint 2 - COMPLETAT]
        └── proves_caiguda_s7.md     [Sprint 3 - COMPLETAT]
```

### Estadístiques del Repositori

| Mètrica | Valor Final | Objectiu Final |
|---------|-------------|----------------|
| Total Commits | 60+ | >60 |
| Branches | 3 (main, dev, feature) | >3 |
| Total Arxius | 50+ | ~50 |
| Línies de Codi | ~2,000 | ~2,000 |
| Documentació (Markdown) | 18 fitxers | >18 |
| Captures ProofHub | 15+ | >15 |
| Contributors | 2 (Hamza, Kevin) | 2 |

---

## Proves i Validació

### Pla de Proves

#### 1. Proves Operatives (OP) - Sprint 1 [COMPLETAT]

| ID | Descripció | Resultat Esperat | Estat | Data |
|----|------------|------------------|-------|------|
| OP-01 | Accedir a http://IP_SERVIDOR | Pàgina carrega correctament amb formulari | COMPLETAT | 19/01/2026 |
| OP-02 | Publicar post sense imatge | Post apareix a la llista | COMPLETAT | 19/01/2026 |
| OP-03 | Publicar post amb imatge | Post i imatge visibles | COMPLETAT | 19/01/2026 |
| OP-04 | Verificar CSS carrega | Estils aplicats correctament | COMPLETAT | 19/01/2026 |
| OP-05 | Publicar 10 posts seguits | Tots els posts visibles en ordre | COMPLETAT | 19/01/2026 |
| OP-06 | Pujar imatge > 5MB | Imatge es guarda correctament | COMPLETAT | 19/01/2026 |

---

#### 2. Proves de Balanceig de Càrrega (BL) - Sprint 2 [COMPLETAT]

| ID | Descripció | Resultat Esperat | Estat | Data |
|----|------------|------------------|-------|------|
| BL-01 | Distribució Round-Robin | 50% peticions a S2, 50% a S3 | COMPLETAT | 02/02/2026 |
| BL-02 | 100 peticions concurrents | Balanceig uniforme | COMPLETAT | 02/02/2026 |
| BL-03 | Temps de resposta | < 2 segons per petició | COMPLETAT | 02/02/2026 |

**Comanda de prova:**
```bash
for i in {1..20}; do curl -s http://localhost/extagram.php > /dev/null; done
docker compose logs --tail=20 s2-php s3-php | grep "GET /extagram.php"
```

---

#### 3. Proves de Segmentació de Xarxa (SX) - Sprint 2 [COMPLETAT]

| ID | Descripció | Resultat Esperat | Estat | Data |
|----|------------|------------------|-------|------|
| SX-01 | S2 → S7 (MySQL) | Connexió exitosa | COMPLETAT | 02/02/2026 |
| SX-02 | S3 → S8 (LDAP) | Connexió exitosa | COMPLETAT | 02/02/2026 |
| SX-03 | S5 → S7 (MySQL) | Connexió bloquejada | COMPLETAT | 02/02/2026 |
| SX-04 | S6 → S8 (LDAP) | Connexió bloquejada | COMPLETAT | 02/02/2026 |
| SX-05 | S1 → S7 (MySQL) | Connexió bloquejada | COMPLETAT | 02/02/2026 |

**Comandes de prova:**
```bash
# Connexions permeses
docker exec extagram-s2-php ping -c 2 172.21.0.2
docker exec extagram-s3-php ping -c 2 172.21.0.3

# Connexions bloquejades
docker exec extagram-s5-images ping -c 2 172.21.0.2  # Ha de fallar
docker exec extagram-s6-static ping -c 2 172.21.0.3  # Ha de fallar
```

---

#### 4. Proves d'Autenticació LDAP (AL) - Sprint 2 [COMPLETAT]

| ID | Descripció | Resultat Esperat | Estat | Data |
|----|------------|------------------|-------|------|
| AL-01 | Login amb usuari Hamza | Accés concedit | COMPLETAT | 02/02/2026 |
| AL-02 | Login amb usuari Kevin | Accés concedit | COMPLETAT | 02/02/2026 |
| AL-03 | Login amb credencials incorrectes | Accés denegat | COMPLETAT | 02/02/2026 |

---

#### 5. Proves de Caiguda de Nodes (CD) - Sprint 3 [COMPLETAT]

| ID | Descripció | Resultat Esperat | Estat | Data |
|----|------------|------------------|-------|------|
| CD-01 | Parar S2, accedir /extagram.php | Funciona via S3, sense errors | COMPLETAT | 04/02/2026 |
| CD-02 | Parar S3, accedir /extagram.php | Funciona via S2, sense errors | COMPLETAT | 04/02/2026 |
| CD-03 | Parar S2 i S3 simultàniament | Error 502 Bad Gateway | COMPLETAT | 04/02/2026 |
| CD-04 | Recuperar S2 després de CD-01 | Balanceig es restaura automàticament | COMPLETAT | 04/02/2026 |
| CD-05 | Parar S7 (MySQL) | Errors de connexió a DB | COMPLETAT | 04/02/2026 |

**Comandes de prova:**
```bash
# CD-01: Parar S2
docker compose stop s2-php
curl -I http://localhost/extagram.php  # Ha de retornar 200 OK
docker compose start s2-php

# CD-02: Parar S3
docker compose stop s3-php
curl -I http://localhost/extagram.php  # Ha de retornar 200 OK
docker compose start s3-php

# CD-03: Parar S2 i S3
docker compose stop s2-php s3-php
curl -I http://localhost/extagram.php  # Ha de retornar 502
docker compose start s2-php s3-php

# CD-05: Parar S7
docker compose stop s7-database
curl -I http://localhost/extagram.php  # Error SQL
docker compose start s7-database
```

---

#### 6. Proves de Rendiment (PR) - Sprint 3 [COMPLETAT]

| ID | Descripció | Eina | Resultat Obtingut | Estat |
|----|------------|------|-------------------|-------|
| PR-01 | 100 peticions simultànies | Apache Bench | 0% fallades | COMPLETAT |
| PR-02 | Temps de resposta mitjà | Apache Bench | ~450ms | COMPLETAT |
| PR-03 | Throughput (req/s) | Apache Bench | ~120 req/s | COMPLETAT |

**Comanda de prova:**
```bash
ab -n 100 -c 10 http://localhost/extagram.php
```

---

### Resultats de Proves

Tots els resultats detallats es troben a:
- [docs/PROVES.md](docs/PROVES.md)
- [proves/resultats/proves_caiguda_s7.md](proves/resultats/proves_caiguda_s7.md)

---

## Gestió de Riscos

### Riscos Identificats i Plans de Mitigació

| ID | Risc | Probabilitat | Impacte | Mitigació | Estat |
|----|------|--------------|---------|-----------|-------|
| R01 | Fallada de node PHP (S2 o S3) | Mitjana | Alt | Redundància amb balanceig (S2 + S3) | MITIGAT |
| R02 | Pèrdua de dades BBDD | Baixa | Molt Alt | Volum persistent `db_data` | MITIGAT |
| R03 | Pèrdua d'imatges pujades | Baixa | Mitjà | Volum persistent `uploads_data` | MITIGAT |
| R04 | Compromís de servidors estàtics | Mitjana | Alt | Segmentació de xarxa - S5/S6 sense accés a BD | MITIGAT |
| R05 | Atac directe a base de dades | Baixa | Molt Alt | Xarxa internal - S7/S8 no exposats a Internet | MITIGAT |
| R06 | Errors de xarxa Docker | Mitjana | Alt | Xarxes segmentades amb DNS intern | MITIGAT |
| R07 | Sobrecàrrega del Load Balancer | Baixa | Mitjà | NGINX Alpine (lleuger i ràpid) | MITIGAT |
| R08 | Fallada completa del servidor | Baixa | Molt Alt | Backups periòdics + documentació de recovery | DOCUMENTAT |
| R09 | Problemes de comunicació equip | Mitjana | Mitjà | Dailies diàries + ProofHub actualitzat | MITIGAT |
| R10 | Retard en lliuraments de tasques | Mitjana | Alt | Sprint Planning detallat + seguiment diari | MITIGAT |

---

### Accions de Contingència

#### Si falla S2 o S3:
1. El Load Balancer (S1) redirigeix automàticament tot el tràfic al node actiu
2. No es requereix intervenció manual
3. Temps de recuperació: < 5 segons

#### Si falla S7 (MySQL):
1. Els serveis PHP retornen errors de connexió
2. Recuperar el contenidor: `docker compose restart s7-database`
3. Les dades es mantenen al volum `db_data`
4. Temps de recuperació: ~10 segons

#### Si es compromet S5 o S6:
1. L'atacant NO pot accedir a S7 (MySQL) ni S8 (LDAP) per segmentació de xarxa
2. Només pot servir arxius estàtics
3. Reiniciar contenidor: `docker compose restart s5-images`

#### Si es perden dades:
1. Restaurar des de backup
2. Reconstruir base de dades amb `init.sql`
3. Re-desplegar contenidors

---

## Metodologia Agile

### Framework Scrum Aplicat

El projecte Extagram s'ha desenvolupat seguint el framework **Scrum**, una metodologia àgil que permet iteracions ràpides i adaptació contínua.

#### Estructura de Sprints

Cada sprint segueix aquest cicle:
```
Sprint Planning
      ↓
Daily Standups (15 min diaris)
      ↓
Desenvolupament (1-5 setmanes)
      ↓
Sprint Review (Demo al tutor)
      ↓
Sprint Retrospective (Millora contínua)
      ↓
[Repeteix per al següent sprint]
```

---

### Rols Scrum

| Rol | Membre | Responsabilitats |
|-----|--------|------------------|
| **Product Owner** | Hamza | Definir Product Backlog<br>Prioritzar tasques<br>Acceptar o rebutjar entregables |
| **Scrum Master** | Hamza | Facilitar ceremonies<br>Eliminar impediments<br>Assegurar seguiment de Scrum |
| **Development Team** | Hamza, Kevin | Desenvolupar funcionalitats<br>Auto-organització<br>Comprometre's amb Sprint Goals |

---

### Ceremonies Scrum

#### 1. Sprint Planning

- **Freqüència:** Inici de cada sprint
- **Durada:** 1-2 hores
- **Participants:** Tot l'equip
- **Objectiu:** Definir el Sprint Goal i seleccionar tasques del Product Backlog
- **Entregable:** Sprint Backlog amb tasques estimades i assignades

**Enllaços:**
- [Sprint 1 Planning](actes/sprint1/SPRINT1_PLANNING.md)
- [Sprint 2 Planning](actes/sprint2/SPRINT2_PLANNING.md)
- [Sprint 3 Planning](actes/sprint3/SPRINT3_PLANNING.md)

---

#### 2. Daily Standup

- **Freqüència:** Diari (15:30h)
- **Durada:** 15 minuts màxim
- **Participants:** Tot l'equip
- **Format:**
  - Què faré avui?
  - Tinc algun bloqueig?

**Daily:**
```
Daily Standup - 04/02/2026

Hamza:
- Avui: Proves de caiguda S7 i documentació resultats
- Bloquejos: Cap

Kevin:
- Avui: Finalitzar diagrama Packet Tracer
- Bloquejos: Cap
```

---

#### 3. Sprint Review

- **Freqüència:** Final de cada sprint
- **Durada:** 1-2 hores
- **Participants:** Equip + Tutor
- **Objectiu:** Demo de les funcionalitats completades
- **Entregable:** Increment del producte funcionant

**Enllaços:**
- [Sprint 1 Review](actes/sprint1/SPRINT1_REVIEW.md) - Completat 19/01/2026
- [Sprint 2 Review](actes/sprint2/SPRINT2_REVIEW.md) - Completat 02/02/2026
- [Sprint 3 Review](actes/sprint3/SPRINT3_REVIEW.md) - Completat 10/02/2026

---

#### 4. Sprint Retrospective

- **Freqüència:** Final de cada sprint (després del Review)
- **Durada:** 1 hora
- **Participants:** Equip (sense tutor)
- **Objectiu:** Millorar el procés de treball
- **Format:**
  - Què ha anat bé?
  - Què podria millorar?
  - Accions de millora per al proper sprint

**Exemple Sprint 3 Retrospective:**
```
Què ha anat bé:
- Proves de caiguda completades amb èxit
- Documentació final exhaustiva
- Excel·lent col·laboració en tasques finals

Què podria millorar:
- Planificar millor temps per a presentació
- Fer més proves de rendiment
- Documentar decisions en temps real

Lliçons apreses:
- Importància de la segmentació de xarxa
- Docker Compose simplifica enormement el desplegament
- Documentació contínua és clau per a projectes llargs
```

---

### Convencions de Commits

Seguim el format **Conventional Commits** per a claredat:
```
<tipus>(<abast>): <descripció curta>

[cos opcional]

[peu opcional]
```

**Tipus de commits:**

- `feat:` Nova funcionalitat
- `fix:` Correcció de bug
- `docs:` Canvis en documentació
- `style:` Formatació, espais, etc.
- `refactor:` Reestructuració de codi
- `test:` Afegir o modificar proves
- `chore:` Tasques de manteniment

**Exemples:**
```bash
git commit -m "feat(docker): afegir S8 OpenLDAP per autenticació d'usuaris"
git commit -m "feat(network): implementar segmentació de xarxa en 3 capes"
git commit -m "fix(nginx): corregir balanceig Round-Robin entre S2 i S3"
git commit -m "docs(readme): actualitzar arquitectura amb 8 serveis i IPs"
git commit -m "test(failover): proves de caiguda S7 MySQL completades"
```

---

### Flux de Treball
```bash
# 1. Crear nova branca per a funcionalitat
git checkout -b feature/nom-funcionalitat

# 2. Fer canvis i commits freqüents
git add .
git commit -m "feat(funcionalitat): descripció"

# 3. Pujar canvis al repositori remot
git push origin feature/nom-funcionalitat

# 4. Crear Pull Request a GitHub

# 5. Revisió de codi per un company

# 6. Merge a main (després de review)
git checkout main
git merge feature/nom-funcionalitat

# 7. Esborrar branca temporal
git branch -d feature/nom-funcionalitat
```

---

### Estadístiques de Git
```bash
# Veure historial de commits
git log --oneline --graph --all

# Estadístiques de contribucions
git shortlog -sn

# Línies de codi afegides/eliminades
git log --stat
```

---

## Documentació

### Documents del Projecte

Tota la documentació es troba al directori `/docs`:

| Document | Descripció | Enllaç |
|----------|------------|--------|
| **README.md** | Documentació principal (aquest fitxer) | [README.md](README.md) |
| **ANALISI_PROJECTE.md** | Anàlisi exhaustiu del projecte | [docs/ANALISI_PROJECTE.md](docs/ANALISI_PROJECTE.md) |
| **GUIA_INSTALACIO.md** | Guia pas a pas d'instal·lació | [docs/GUIA_INSTALACIO.md](docs/GUIA_INSTALACIO.md) |
| **ARQUITECTURA.md** | Arquitectura tècnica detallada | [docs/ARQUITECTURA.md](docs/ARQUITECTURA.md) |
| **PROVES.md** | Pla de proves i resultats | [docs/PROVES.md](docs/PROVES.md) |
| **MANTENIMENT.md** | Guia de manteniment i troubleshooting | [docs/MANTENIMENT.md](docs/MANTENIMENT.md) |

---

### Actes de Sprints

Totes les actes de reunions es troben al directori `/actes`:

- [Sprint 1 Planning](actes/sprint1/SPRINT1_PLANNING.md)
- [Sprint 1 Review](actes/sprint1/SPRINT1_REVIEW.md)
- [Sprint 2 Planning](actes/sprint2/SPRINT2_PLANNING.md)
- [Sprint 2 Review](actes/sprint2/SPRINT2_REVIEW.md)
- [Sprint 3 Planning](actes/sprint3/SPRINT3_PLANNING.md)
- [Sprint 3 Review](actes/sprint3/SPRINT3_REVIEW.md)

---

### Captures de ProofHub

Totes les captures del dashboard de ProofHub es troben a:

- [/actes/sprint1/captures/](/actes/sprint1/captures/)
- [/actes/sprint2/captures/](/actes/sprint2/captures/)
- [/actes/sprint3/captures/](/actes/sprint3/captures/)

---

## Contacte i Suport

### Membres de l'Equip

| Nom | Rol | Email | GitHub |
|-----|-----|-------|--------|
| Hamza | Product Owner / DevOps / Backend | hamza.tayibi.7e6@itb.cat | [@HamzaTayibiITB2425](https://github.com/HamzaTayibiITB2425) |
| Kevin | Infrastructure Engineer | kevin.armada.7e4@students.itb.cat | [@KevinArmada-ITB2425](https://github.com/KevinArmada-ITB2425) |

---

### Institut i Tutor

**Institut Tecnològic de Barcelona**  
Carrer d'Aiguablava, 121, Nou Barris, 08033 Barcelona  
Web: [www.itb.cat](https://www.itb.cat)

**Tutor del Projecte:** Jordi Casas  
Email: jordi.casas@itb.cat

---

### Recursos Addicionals

- [Documentació Docker](https://docs.docker.com)
- [Documentació NGINX](https://nginx.org/en/docs/)
- [Documentació PHP](https://www.php.net/docs.php)
- [Documentació MySQL](https://dev.mysql.com/doc/)
- [Documentació OpenLDAP](https://www.openldap.org/doc/)
- [Guia Scrum](https://scrumguides.org/)

---

## Llicència

Aquest projecte és desenvolupat amb finalitats **educatives** per a l'assignatura de Projecte Intermodular de l'ASIX2c a l'Institut Tecnològic de Barcelona.
```
Copyright (c) 2026 Hamza, Kevin - Institut Tecnològic de Barcelona
Tots els drets reservats per a ús educatiu.
```

---

## Agraïments

- **Institut Tecnològic de Barcelona** per proporcionar la infraestructura i suport
- **Professor Jordi Casas** per la tutoria i guia durant el projecte
- **Comunitat Docker** per l'excel·lent documentació
- **Comunitat NGINX** per les millors pràctiques
- **OpenLDAP Project** per l'autenticació centralitzada
- **Stack Overflow** per resoldre dubtes tècnics

---

<div align="center">

**Projecte Extagram - Institut Tecnològic de Barcelona**  
**Equip:** Hamza, Kevin | **ASIX2c** | **2025-2026**

**PROJECTE COMPLETAT AMB ÈXIT**

[Torna a l'índex](#índex)

</div>

---

**Última actualització:** 10 de Febrer de 2026  
**Versió del Document:** 5.0  
**Estat del Projecte:** COMPLETAT
