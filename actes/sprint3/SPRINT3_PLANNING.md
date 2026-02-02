# ACTA - Sprint 3 Planning

## Informacio de la Reunio

| Camp | Valor |
|------|-------|
| Data | 02/02/2026 |
| Hora | 15:00 - 15:30 |
| Lloc | Aula ASIX |
| Sprint | Sprint 3 |
| Duracio Sprint | 02/02/2026 - 16/02/2026 |

## Assistents

| Nom | Rol | Assistencia |
|-----|-----|-------------|
| Hamza | Product Owner / DevOps Lead | Present |
| Kevin | Infrastructure / Frontend | Present |

---

## 1. Objectiu del Sprint

Completar la integracio del sistema, crear l'esquema de xarxa amb Packet Tracer, realitzar proves de caiguda de nodes i preparar la documentacio final per a la presentacio.

---

## 2. Backlog del Sprint

| ID | Tasca | Assignat | Estimacio | Prioritat |
|----|-------|----------|-----------|-----------|
| T3.1 | Crear esquema de xarxa amb Packet Tracer | Kevin | 3h | Alta |
| T3.2 | Documentar arquitectura de xarxa | Kevin | 2h | Alta |
| T3.3 | Proves de caiguda node S2 | Hamza, Kevin | 1.5h | Alta |
| T3.4 | Proves de caiguda node S3 | Hamza, Kevin | 1.5h | Alta |
| T3.5 | Proves de caiguda BBDD | Hamza, Kevin | 2h | Alta |
| T3.6 | Documentar resultats de proves | Hamza, Kevin | 2h | Alta |
| T3.7 | Revisar i completar documentacio | Hamza | 3h | Alta |
| T3.8 | Preparar presentacio | Hamza | 2h | Alta |
| T3.9 | Revisar control de versions Git | Hamza | 1h | Mitjana |
| T3.10 | Proves finals integrades | Tots | 2h | Alta |
| T3.11 | Sprint Review Final | Tots | 2h | Alta |
| T3.12 | Implementació LDAP | Tots | 2h | Alta |

---

## 3. Proves a Realitzar

### Proves Operatives

| Prova | Descripcio | Resultat Esperat |
|-------|------------|------------------|
| OP-01 | Acces a l'aplicacio | Pagina carrega correctament |
| OP-02 | Publicar post sense imatge | Post apareix a la llista |
| OP-03 | Publicar post amb imatge | Post i imatge visibles |

### Proves de Caiguda de Nodes

| Prova | Descripcio | Resultat Esperat |
|-------|------------|------------------|
| CD-01 | Parar S2, accedir aplicacio | Funciona via S3 |
| CD-02 | Parar S3, accedir aplicacio | Funciona via S2 |
| CD-03 | Parar S2 i S3 | Error esperat |

---

## 4. Captura ProofHub

![ProofHub Sprint 3](./captures/proofhub_sprint3_planning.png)

---

## 5. Team

| Rol | Nom |
|-----|-----|
| Product Owner | Hamza | 
| Developer | Kevin |

---

Acta generada: 02/02/2026
