# Configuració SSL - Let's Encrypt

## Índex

1. [Introducció](#introducció)
2. [Pre-requisits](#pre-requisits)
3. [Instal·lació Certbot](#installació-certbot)
4. [Obtenir Certificat SSL](#obtenir-certificat-ssl)
5. [Configuració NGINX](#configuració-nginx)
6. [Renovació Automàtica](#renovació-automàtica)
7. [Verificació SSL](#verificació-ssl)
8. [Troubleshooting](#troubleshooting)

---

## Introducció

Aquest document detalla el procés complet d'instal·lació i configuració de certificats SSL gratuïts amb **Let's Encrypt** utilitzant **Certbot** per al projecte Extagram.

**Objectiu:** Configurar HTTPS amb certificats vàlids i renovació automàtica.

---

## Pre-requisits

Abans de començar, assegura't de tenir:

### 1. Domini Públic Configurat

**Domini utilitzat:** `extagram-grup3.duckdns.org`

**Verificar DNS:**
```bash
dig extagram-grup3.duckdns.org +short
# Ha de retornar la IP pública del servidor
```

o
```bash
nslookup extagram-grup3.duckdns.org
# Ha de mostrar la IP correcta
```

### 2. Ports Oberts

**Ports necessaris:**
- **Port 80 (HTTP)** - Per validació de Let's Encrypt
- **Port 443 (HTTPS)** - Per tràfic HTTPS

**Verificar ports:**
```bash
sudo netstat -tlnp | grep -E ':(80|443)'
```

### 3. NGINX Instal·lat
```bash
nginx -v
# nginx version: nginx/1.18.0 (Ubuntu)
```

---

## Instal·lació Certbot

### 1. Actualitzar Repositoris
```bash
sudo apt update
```

### 2. Instal·lar Certbot i Plugin NGINX
```bash
sudo apt install certbot python3-certbot-nginx -y
```

**Verificar instal·lació:**
```bash
certbot --version
# certbot 1.21.0
```

---

## Obtenir Certificat SSL

### Mètode 1: Amb Plugin NGINX (Recomanat)

**Comanda:**
```bash
sudo certbot --nginx -d extagram-grup3.duckdns.org
```

**Procés interactiu:**

1. **Email:**
```
Enter email address (used for urgent renewal and security notices):
hamza@example.com
```

2. **Termes de servei:**
```
Please read the Terms of Service at https://letsencrypt.org/documents/LE-SA-v1.2-November-15-2017.pdf
(A)gree/(C)ancel: A
```

3. **Newsletter (opcional):**
```
Would you be willing to share your email address with the Electronic Frontier Foundation?
(Y)es/(N)o: N
```

4. **Configuració HTTPS:**
```
Please choose whether or not to redirect HTTP traffic to HTTPS:
1: No redirect
2: Redirect - Make all requests redirect to secure HTTPS access
Select the appropriate number [1-2]: 2
```

**Sortida esperada:**
```
Congratulations! You have successfully enabled https://extagram-grup3.duckdns.org

You should test your configuration at:
https://www.ssllabs.com/ssltest/analyze.html?d=extagram-grup3.duckdns.org
```

### Mètode 2: Standalone (Sense NGINX corrent)

**Si NGINX no està corrent:**
```bash
sudo systemctl stop nginx
sudo certbot certonly --standalone -d extagram-grup3.duckdns.org
sudo systemctl start nginx
```

### Mètode 3: Webroot (NGINX corrent, sense plugin)
```bash
sudo certbot certonly --webroot -w /var/www/html -d extagram-grup3.duckdns.org
```

---

## Configuració NGINX

### Ubicació dels Certificats

**Let's Encrypt guarda els certificats a:**
```
/etc/letsencrypt/live/extagram-grup3.duckdns.org/
├── cert.pem         # Certificat del domini
├── chain.pem        # Cadena de certificació
├── fullchain.pem    # cert.pem + chain.pem (USAR AQUEST)
└── privkey.pem      # Clau privada
```

### Configuració Manual NGINX

**Arxiu:** `/etc/nginx/sites-available/extagram` o dins del contenidor S1
```nginx
server {
    listen 80;
    server_name extagram-grup3.duckdns.org;
    
    # Redirect HTTP to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name extagram-grup3.duckdns.org;

    # SSL Configuration
    ssl_certificate /etc/letsencrypt/live/extagram-grup3.duckdns.org/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/extagram-grup3.duckdns.org/privkey.pem;

    # SSL Security Settings
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384';
    ssl_prefer_server_ciphers off;

    # SSL Session Cache
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    # OCSP Stapling
    ssl_stapling on;
    ssl_stapling_verify on;
    ssl_trusted_certificate /etc/letsencrypt/live/extagram-grup3.duckdns.org/chain.pem;

    # Security Headers
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "SAMEORIGIN" always;

    # Rest of your configuration...
    location / {
        proxy_pass http://backend;
        # ...
    }
}
```

### Configuració en Docker Compose

**docker-compose.yml:**
```yaml
s1-loadbalancer:
  image: nginx:alpine
  container_name: extagram-s1-loadbalancer
  ports:
    - "80:80"
    - "443:443"
  volumes:
    - ./s1-loadbalancer/nginx.conf:/etc/nginx/nginx.conf:ro
    - /etc/letsencrypt:/etc/letsencrypt:ro  # Montar certificats
  restart: unless-stopped
```

**Reiniciar contenidor:**
```bash
docker compose restart s1-loadbalancer
```

---

## Renovació Automàtica

### Verificar Timer de Renovació

Certbot instal·la automàticament un timer systemd per renovar certificats:
```bash
sudo systemctl status certbot.timer
```

**Sortida esperada:**
```
● certbot.timer - Run certbot twice daily
     Loaded: loaded (/lib/systemd/system/certbot.timer; enabled)
     Active: active (waiting)
```

### Provar Renovació Manual

**Dry-run (sense aplicar canvis):**
```bash
sudo certbot renew --dry-run
```

**Sortida esperada:**
```
Congratulations, all simulated renewals succeeded:
  /etc/letsencrypt/live/extagram-grup3.duckdns.org/fullchain.pem (success)
```

### Renovació Manual Forçada

**Només si cal renovar abans de temps:**
```bash
sudo certbot renew --force-renewal
```

### Configurar Hook Post-Renewal

**Crear script:** `/etc/letsencrypt/renewal-hooks/post/reload-nginx.sh`
```bash
#!/bin/bash
# Reload NGINX després de renovar certificat

docker compose -f /home/ubuntu/extagram-project/configuracions/docker/docker-compose.yml restart s1-loadbalancer

echo "$(date): Certificado renovado, NGINX reloaded" >> /var/log/certbot-renewal.log
```

**Donar permisos d'execució:**
```bash
sudo chmod +x /etc/letsencrypt/renewal-hooks/post/reload-nginx.sh
```

**Provar hook:**
```bash
sudo certbot renew --dry-run
# El script s'executarà després de la renovació
```

---

## Verificació SSL

### 1. Verificar amb cURL
```bash
curl -I https://extagram-grup3.duckdns.org
```

**Sortida esperada:**
```
HTTP/2 200
server: nginx/1.25.3
date: Mon, 10 Mar 2026 14:00:00 GMT
content-type: text/html; charset=UTF-8
strict-transport-security: max-age=31536000; includeSubDomains
```

### 2. Verificar Certificat
```bash
openssl s_client -connect extagram-grup3.duckdns.org:443 -servername extagram-grup3.duckdns.org
```

**Buscar:**
```
subject=CN = extagram-grup3.duckdns.org
issuer=C = US, O = Let's Encrypt, CN = R3
```

### 3. Verificar Data de Caducitat
```bash
echo | openssl s_client -servername extagram-grup3.duckdns.org -connect extagram-grup3.duckdns.org:443 2>/dev/null | openssl x509 -noout -dates
```

**Sortida:**
```
notBefore=Mar  1 10:00:00 2026 GMT
notAfter=May  30 10:00:00 2026 GMT
```

### 4. Test Online SSL Labs

**URL:** https://www.ssllabs.com/ssltest/analyze.html?d=extagram-grup3.duckdns.org

**Qualificació esperada:** A o A+

### 5. Verificar HSTS
```bash
curl -I https://extagram-grup3.duckdns.org | grep -i strict
```

**Esperat:**
```
strict-transport-security: max-age=31536000; includeSubDomains
```

---

## Troubleshooting

### Problema 1: Error "Connection Refused"

**Simptoma:**
```bash
curl https://extagram-grup3.duckdns.org
curl: (7) Failed to connect to extagram-grup3.duckdns.org port 443: Connection refused
```

**Solucions:**

**1. Verificar que NGINX escolta al port 443:**
```bash
sudo netstat -tlnp | grep :443
```

**2. Verificar configuració NGINX:**
```bash
sudo nginx -t
```

**3. Reiniciar NGINX:**
```bash
sudo systemctl restart nginx
# o
docker compose restart s1-loadbalancer
```

### Problema 2: "Certificate Verification Failed"

**Simptoma:**
```bash
curl https://extagram-grup3.duckdns.org
curl: (60) SSL certificate problem: unable to get local issuer certificate
```

**Solucions:**

**1. Verificar que fullchain.pem està en ús:**
```nginx
ssl_certificate /etc/letsencrypt/live/extagram-grup3.duckdns.org/fullchain.pem;
# NO usar cert.pem (incomplet)
```

**2. Verificar permisos dels certificats:**
```bash
sudo ls -la /etc/letsencrypt/live/extagram-grup3.duckdns.org/
```

### Problema 3: "Rate Limit Exceeded"

**Simptoma:**
```
Error: too many certificates already issued for exact set of domains
```

**Causa:** Let's Encrypt limita a 5 certificats per setmana pel mateix domini.

**Solució:**
- Utilitzar `--dry-run` per provar sense generar certificats reals
- Esperar 1 setmana abans de tornar a intentar
- Utilitzar staging environment per proves:
```bash
sudo certbot --nginx -d extagram-grup3.duckdns.org --staging
```

### Problema 4: Renovació Automàtica no Funciona

**Verificar:**

**1. Timer actiu:**
```bash
sudo systemctl status certbot.timer
```

**2. Logs de renovació:**
```bash
sudo journalctl -u certbot.service
```

**3. Provar renovació manual:**
```bash
sudo certbot renew --dry-run
```

**4. Verificar hook post-renewal:**
```bash
sudo ls -la /etc/letsencrypt/renewal-hooks/post/
```

### Problema 5: "Port 80 Already in Use"

**Simptoma:**
```
Problem binding to port 80: Could not bind to IPv4 or IPv6.
```

**Solució:**

**Utilitzar webroot o nginx plugin en comptes de standalone:**
```bash
# Opció 1: Webroot
sudo certbot certonly --webroot -w /var/www/html -d extagram-grup3.duckdns.org

# Opció 2: NGINX plugin (millor)
sudo certbot --nginx -d extagram-grup3.duckdns.org
```

---

## Comandes Útils

### Ver Certificats Instal·lats
```bash
sudo certbot certificates
```

### Revocar Certificat
```bash
sudo certbot revoke --cert-path /etc/letsencrypt/live/extagram-grup3.duckdns.org/cert.pem
```

### Eliminar Certificat
```bash
sudo certbot delete --cert-name extagram-grup3.duckdns.org
```

### Renovar Certificats
```bash
sudo certbot renew
```

### Veure Configuració de Renovació
```bash
sudo cat /etc/letsencrypt/renewal/extagram-grup3.duckdns.org.conf
```

---

## Millors Pràctiques

1. **Utilitzar fullchain.pem** - No cert.pem (incomplet)
2. **Habilitar HSTS** - Força HTTPS per 1 any mínim
3. **Configurar auto-renewal** - Verificar timer systemd actiu
4. **Utilitzar TLS 1.2+** - Deshabilitar TLS 1.0/1.1
5. **OCSP Stapling** - Millora rendiment verificació certificat
6. **Monitoritzar expiració** - Alertes abans de 30 dies
7. **Testejar SSL Labs** - Objectiu: A o A+

---

**Document elaborat per:** Hamza  
**Data:** 10 de Març de 2026  
**Versió:** 1.0
