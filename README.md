# Projecte Extagram - Desplegament d'Alta Disponibilitat

## Informacio del Projecte

| Camp | Valor |
|------|-------|
| Modul | 0379 - Projecte intermodular d'administracio de sistemes informatics en xarxa |
| Activitat | P0.1 - Desplegament aplicacio Extagram |
| Institut | Institut Tecnologic de Barcelona |
| Curs | ASIX2c |
| Data Inici | 15/12/2025 |
| Data Fi | 10/02/2026 |

---

## Equip de Treball

| Membre | Rol | Responsabilitats |
|--------|-----|------------------|
| Hamza | Product Owner / DevOps Lead | Gestio del projecte, documentacio, configuracio Docker, coordinacio |
| Steven | Backend Developer / DBA | Configuracio PHP-FPM, MySQL, scripts de base de dades, proves |
| Kevin | Infrastructure / Frontend | Configuracio NGINX, proxy invers, balanceig de carrega, arxius estatics |

---

## Estructura del Repositori

```
extagram-project/
├── README.md
├── docs/
│   ├── ANALISI_PROJECTE.md
│   ├── GUIA_INSTALACIO.md
│   └── PROVES.md
├── actes/
│   ├── sprint1/
│   ├── sprint2/
│   └── sprint3/
├── configuracions/
│   └── docker/
├── src/
└── xarxa/
```

---

## Planificacio d'Sprints

### Sprint 1: Analisi i MVP (15/12/2025 - 19/01/2026)

Objectiu: Servidor web funcional en una sola maquina

### Sprint 2: Dockeritzacio (19/01/2026 - 27/01/2026)

Objectiu: Segregacio de serveis amb Docker

### Sprint 3: Integracio i Proves (02/02/2026 - 10/02/2026)

Objectiu: Sistema complet amb proves

---

## Tecnologies Utilitzades

| Tecnologia | Versio | Us |
|------------|--------|-----|
| NGINX | Alpine | Proxy invers, balanceig, servidor estatic |
| PHP-FPM | 8.x | Execucio scripts PHP |
| MySQL | 8.x | Base de dades |
| Docker | Latest | Contenidors |
| Docker Compose | v2 | Orquestracio |
| Git/GitHub | - | Control de versions |
| ProofHub | - | Gestio de projecte |

---

## Arquitectura del Sistema

```
                    +-------------+
                    |   Browser   |
                    +------+------+
                           |
                    +------v------+
                    |     S1      |
                    | Load Balancer|
                    +------+------+
           +---------------+---------------+---------------+
           |               |               |               |
    +------v------+ +------v------+ +------v------+ +------v------+
    |  S2 & S3    | |     S4      | |     S5      | |     S6      |
    | extagram.php| | upload.php  | |   images    | |   static    |
    +------+------+ +------+------+ +------+------+ +-------------+
           |               |               |
           +-------+-------+               |
                   |                       |
            +------v------+         +------v------+
            |     S7      |         |   uploads/  |
            |   MySQL     |         |   (Volume)  |
            +-------------+         +-------------+
```

---

## Control de Versions

```bash
git clone git@github.com:usuari/extagram-project.git
git add .
git commit -m "descripcio del canvi"
git push origin main
```

---

Ultima actualitzacio: 15/12/2025
