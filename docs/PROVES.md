# Document de Proves - Projecte Extagram

## 1. Proves Operatives

| ID | Prova | Resultat Esperat | Resultat | Estat |
|----|-------|------------------|----------|-------|
| OP-01 | Acces a l'aplicacio | Pagina carrega | | |
| OP-02 | Publicar post sense imatge | Post visible | | |
| OP-03 | Publicar post amb imatge | Post i imatge visibles | | |
| OP-04 | Verificar CSS | Estils aplicats | | |
| OP-05 | Multiples posts | Tots visibles | | |

## 2. Proves de Balanceig

| ID | Prova | Resultat Esperat | Resultat | Estat |
|----|-------|------------------|----------|-------|
| BL-01 | Distribucio peticions | 50% S2, 50% S3 | | |

## 3. Proves de Caiguda

| ID | Prova | Resultat Esperat | Resultat | Estat |
|----|-------|------------------|----------|-------|
| CD-01 | Caiguda S2 | Funciona via S3 | | |
| CD-02 | Caiguda S3 | Funciona via S2 | | |
| CD-03 | Caiguda S2+S3 | Error 502 | | |
| CD-04 | Recuperacio | Servei restaurat | | |

## 4. Comandes de Prova

```bash
# Proves operatives
curl -I http://localhost
curl http://localhost/extagram.php

# Proves balanceig
docker-compose logs -f s2-php s3-php

# Proves caiguda
docker-compose stop s2-php
curl http://localhost/extagram.php
docker-compose start s2-php
```

---

Document creat per: Equip Extagram
