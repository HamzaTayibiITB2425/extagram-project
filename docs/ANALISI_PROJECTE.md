# Analisi del Projecte Extagram

## 1. Introduccio

### 1.1 Objectiu
Desplegar l'aplicacio Extagram amb alta disponibilitat i escalabilitat utilitzant Docker.

### 1.2 Abast
- Desplegament inicial en maquina unica (MVP)
- Migracio a arquitectura distribuida amb Docker
- Implementacio de balanceig de carrega
- Alta disponibilitat mitjancant redundancia

---

## 2. Requisits

### 2.1 Funcionals

| ID | Requisit | Prioritat |
|----|----------|-----------|
| RF01 | Pujar imatges | Alta |
| RF02 | Publicar posts | Alta |
| RF03 | Visualitzar posts | Alta |
| RF04 | Emmagatzematge BBDD | Alta |
| RF05 | Balanceig de carrega | Alta |

### 2.2 No Funcionals

| ID | Requisit |
|----|----------|
| RNF01 | Alta disponibilitat |
| RNF02 | Escalabilitat |
| RNF03 | Rendiment < 2s |

---

## 3. Tecnologies

| Component | Tecnologia |
|-----------|------------|
| S1 Load Balancer | nginx:alpine |
| S2-S3 PHP App | php:fpm |
| S4 Upload | php:fpm |
| S5 Images | nginx:alpine |
| S6 Static | nginx:alpine |
| S7 Database | mysql:8 |

---

## 4. Arquitectura

```
Browser --> S1 (Load Balancer)
              |
    +---------+---------+
    |         |         |
   S2/S3     S4        S5/S6
  (PHP)   (Upload)   (Static)
    |         |
    +----+----+
         |
        S7
     (MySQL)
```

---

## 5. Riscos

| Risc | Mitigacio |
|------|-----------|
| Fallada node PHP | Redundancia S2/S3 |
| Perdua dades | Volums persistents |
| Errors xarxa | Xarxa Docker interna |

---

Document creat per: Equip Extagram
Data: 15/12/2025
