# ACTA - Sprint 2 Review

## Informacio de la Reunio

| Camp | Valor |
|------|-------|
| Data | 02/02/2026 |
| Hora | 16:00 - 16:30 |
| Lloc | Aula ASIX |
| Sprint | Sprint 2 |

## Assistents

| Nom | Rol | Assistencia |
|-----|-----|-------------|
| Hamza | Product Owner / DevOps Lead | Present |
| Kevin | Infrastructure / Frontend | Present |

---

## 1. Objectiu del Sprint

Segregar l'aplicacio en contenidors Docker amb proxy invers i balanceig de carrega.

---

## 2. Revisio de Tasques

| ID | Tasca | Assignat | Estat | Comentaris |
|----|-------|----------|-------|------------|
| T2.1 | Dockerfile S2/S3 | Hamza, Kevin | ✓ | Fet |
| T2.2 | Dockerfile S4 | Hamza, Kevin | ✓ | Fet |
| T2.3 | Dockerfile S7 | Hamza, Kevin | ✓ | Fet |
| T2.4 | Config NGINX S1 | Kevin | ✓ | Fet |
| T2.5 | Dockerfile S5 | Kevin | ✓ | Fet |
| T2.6 | Dockerfile S6 | Kevin | ✓ | Fet |
| T2.7 | docker-compose.yml | Hamza | ✓ | Fet |
| T2.8 | Xarxa Docker | Hamza | ✓ | Fet |
| T2.9 | Volums persistents | Hamza | ✓ | Fet |
| T2.10 | Proves balanceig | Tots | ✓ | Fet |
| T2.11 | Documentacio | Hamza | ✓ | Fet |
| T2.12 | Preparar Review | Hamza, Kevin | ✓ | Fet |
| T2.13 | Implementació BLOB | Hamza, Kevin | ✓ | Fet |
| T2.14 | Implementación de Seguridad | Hamza, Kevin | ✓ | Fet |
| T2.15 | Configuración de Red AWS | Hamza, Kevin | ✓ | Fet |
---

## 3. Demostracio

```bash
docker-compose up -d
docker-compose ps
docker-compose logs -f s1-loadbalancer
```

---

## 4. Retrospectiva

### Que ha anat be?

1. Tot i ser un membre menys, hem aconseguit que tots els contenidors es comuniquin perfectament amb el balancejador de càrrega.
2. Hem demostrat capacitat d'adaptació en assumir les tasques del membre que va sortir del grup, mantenint el ritme i assolint els objectius de seguretat i xarxa. 

### Que podria millorar?

1. La sortida d'un membre del grup ens ha obligat a fer massa tasques junts per cobrir buits; hem de redefinir rols per ser més autònoms.
2. En ser menys persones, necessitem simplificar els Dockerfiles i el desplegament a AWS per no saturar-nos amb el manteniment.

---


## 5. Captura ProofHub

![ProofHub Sprint 2 Review](./captures/proofhub_sprint2_review.png)

---

## 6. Team

| Rol | Nom |
|-----|-----|
| Product Owner | Hamza | 
| Developer | Kevin |

---

Acta generada: 02/02/2026
