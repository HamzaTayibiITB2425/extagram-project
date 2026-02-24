# ACTA - Sprint 4 Review

## Informacio de la Reunio

| Camp | Valor |
|------|-------|
| Data | 24/02/2026 |
| Hora | 16:00 - 16:30 |
| Lloc | Aula ASIX |
| Sprint | Sprint 4 |

## Assistents

| Nom | Rol | Assistencia |
|-----|-----|-------------|
| Hamza | Product Owner / DevOps Lead | Present |
| Kevin | Infrastructure / Frontend | Present |

---

## 1. Resum del Sprint

### Objectiu del Sprint

Implementar firewall davant de S1 i Implementar hardening web (WAF), de sistema operatiu i de BBDD

### Resultat

- [x] Objectiu assolit completament
- [ ] Objectiu assolit parcialment
- [ ] Objectiu no assolit

---

## 2. Revisio de Tasques

| ID | Tasca | Assignat | Estat | Comentaris |
|----|-------|----------|-------|------------|
| T4.1 | Implementar Firewall delante de S1 | Kevin | ✓ | Fet |
| T4.2 | Implementar hardening web (WAF), de sistema operatiu i de BBDD | Hamza | ✓ | Fet |


---

---

## 4. Retrospectiva

### Que ha anat be?

1. Implementació WAF NGINX i Firewall: Hem aconseguit implementar un WAF natiu amb NGINX utilitzant regex patterns que bloqueja SQL Injection, XSS i Path Traversal. El Kevin ha configurat el firewall iptables davant del LoadBalancer per protecció perimetral. Tots els tests mostren que funciona correctament (403 Forbidden als atacs). 
2. Hardening complert de tot el sistema: Hem aplicat hardening tant a nivell de contenidors Docker (no-new-privileges, cap_drop: ALL, read_only filesystem) com a MySQL (root només localhost, privilegis mínims per extagram_admin, eliminació d'usuaris anònims). La col·laboració ha estat clau per verificar que tot funcionava correctament.

### Que podria millorar?

1. Coordinació en troubleshooting: Hem perdut temps resolvint problemes amb el proxy_pass de les imatges i els permisos d'escriptura de S4-upload de forma separada. Hauríem pogut comunicar-nos millor per detectar els problemes més ràpid.
2. Planificació inicial del hardening: No vam preveure que aplicar read_only:true als contenidors PHP trencaria els uploads. Hauríem d'haver planificat millor quins serveis necessitaven escriptura i quins no des del principi del sprint.

---

## 5. Captura ProofHub

![ProofHub Sprint 4 Review](./captures/proofhub_sprint4_review.png)

---

## 6. Team

| Rol | Nom | 
|-----|-----|
| Product Owner | Hamza | 
| Developer | Kevin |

---

Acta generada: 23/02/2026
