# Configuració LDAP - OpenLDAP

## Índex

1. [Introducció](#introducció)
2. [Arquitectura LDAP](#arquitectura-ldap)
3. [Instal·lació OpenLDAP](#installació-openldap)
4. [Configuració del Servidor](#configuració-del-servidor)
5. [Estructura de Directori](#estructura-de-directori)
6. [Crear Usuaris](#crear-usuaris)
7. [Integració amb Aplicació](#integració-amb-aplicació)
8. [Verificació LDAP](#verificació-ldap)
9. [Troubleshooting](#troubleshooting)

---

## Introducció

Aquest document detalla la configuració completa del servidor **OpenLDAP** per a l'autenticació centralitzada d'usuaris al projecte Extagram.

**Objectiu:** Configurar OpenLDAP per gestionar usuaris Hamza i Kevin amb autenticació segura.

---

## Arquitectura LDAP

### Posició a l'Arquitectura Extagram
```
Usuari → S1 (Load Balancer) → S2/S3 (PHP) → S8 (OpenLDAP)
                                              ↓
                                        Autenticació
                                     (cn=hamza, cn=kevin)
```

**Característiques:**
- **Xarxa:** `extagram_data` (internal) - NO accessible des d'Internet
- **Port:** 389 (LDAP), 636 (LDAPS)
- **Base DN:** `dc=extagram,dc=local`
- **Usuaris:** hamza, kevin
- **Organització:** `ou=users`

---

## Instal·lació OpenLDAP

### Mètode 1: Docker (Recomanat)

**Docker Compose:**
```yaml
s8-ldap:
  image: osixia/openldap:1.5.0
  container_name: extagram-s8-ldap
  hostname: ldap-server
  restart: unless-stopped
  
  environment:
    - LDAP_ORGANISATION=Extagram
    - LDAP_DOMAIN=extagram.local
    - LDAP_ADMIN_PASSWORD=admin_password_secure
    - LDAP_CONFIG_PASSWORD=config_password_secure
    - LDAP_RFC2307BIS_SCHEMA=true
    - LDAP_REMOVE_CONFIG_AFTER_SETUP=true
    - LDAP_TLS=false
  
  volumes:
    - ./s8-ldap/users.ldif:/container/service/slapd/assets/config/bootstrap/ldif/custom/users.ldif
  
  networks:
    extagram_data:
      ipv4_address: 172.21.0.3
  
  ports:
    - "389:389"
    - "636:636"
```

**Variables d'entorn:**
- `LDAP_ORGANISATION` - Nom de l'organització (Extagram)
- `LDAP_DOMAIN` - Domini LDAP (extagram.local)
- `LDAP_ADMIN_PASSWORD` - Contrasenya admin LDAP
- `LDAP_RFC2307BIS_SCHEMA` - Schema NIS modern

**Iniciar contenidor:**
```bash
docker compose up -d s8-ldap
```

### Mètode 2: Instal·lació Nativa (Ubuntu)
```bash
# Instal·lar OpenLDAP
sudo apt update
sudo apt install slapd ldap-utils -y

# Reconfigurar (definir base DN)
sudo dpkg-reconfigure slapd
```

**Durant la configuració:**
1. Omit OpenLDAP server configuration? **No**
2. DNS domain name: **extagram.local**
3. Organization name: **Extagram**
4. Administrator password: **[contrasenya_segura]**
5. Database backend: **MDB**
6. Remove database when slapd is purged? **No**
7. Move old database? **Yes**

---

## Configuració del Servidor

### Base DN

**Base Distinguished Name (DN):**
```
dc=extagram,dc=local
```

Això es descompon en:
- `dc=extagram` - Domain Component (primer nivell)
- `dc=local` - Domain Component (segon nivell)

**DN complet de l'administrador:**
```
cn=admin,dc=extagram,dc=local
```

### Estructura LDAP
```
dc=extagram,dc=local (Base DN)
    │
    └── ou=users (Organizational Unit - Usuaris)
        │
        ├── cn=hamza (Entry - Usuari Hamza)
        └── cn=kevin (Entry - Usuari Kevin)
```

---

## Estructura de Directori

### Crear Organizational Unit

**Arxiu:** `create_ou.ldif`
```ldif
dn: ou=users,dc=extagram,dc=local
objectClass: organizationalUnit
ou: users
description: Usuaris del sistema Extagram
```

**Aplicar:**
```bash
ldapadd -x -D "cn=admin,dc=extagram,dc=local" -W -f create_ou.ldif
```

o dins del contenidor:
```bash
docker exec -it extagram-s8-ldap ldapadd -x -D "cn=admin,dc=extagram,dc=local" -W -f /tmp/create_ou.ldif
```

---

## Crear Usuaris

### Arxiu LDIF: users.ldif

**Arxiu:** `s8-ldap/users.ldif`
```ldif
# Organizational Unit per usuaris
dn: ou=users,dc=extagram,dc=local
objectClass: organizationalUnit
ou: users
description: Usuaris del sistema Extagram

# Usuari: Hamza
dn: cn=hamza,ou=users,dc=extagram,dc=local
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
cn: hamza
sn: Tayibi
givenName: Hamza
uid: hamza
uidNumber: 10001
gidNumber: 10001
homeDirectory: /home/hamza
loginShell: /bin/bash
mail: hamza.tayibi@extagram.local
userPassword: {SSHA}aGFtemFfc2VjdXJlX3Bhc3N3b3Jk
description: Product Owner / DevOps Lead

# Usuari: Kevin
dn: cn=kevin,ou=users,dc=extagram,dc=local
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
cn: kevin
sn: Armada
givenName: Kevin
uid: kevin
uidNumber: 10002
gidNumber: 10002
homeDirectory: /home/kevin
loginShell: /bin/bash
mail: kevin.armada@extagram.local
userPassword: {SSHA}a2V2aW5fc2VjdXJlX3Bhc3N3b3Jk
description: Infrastructure Engineer / Security
```

**Objectes:**
- `inetOrgPerson` - Atributs de persona (nom, email)
- `posixAccount` - Atributs Unix (UID, home)
- `shadowAccount` - Informació de contrasenya

**Atributs clau:**
- `cn` (Common Name) - Nom complet
- `sn` (Surname) - Cognom
- `givenName` - Nom de pila
- `uid` - User ID (login)
- `uidNumber` - UID numèric Unix
- `gidNumber` - GID numèric Unix
- `userPassword` - Contrasenya (encriptada SSHA)

### Generar Contrasenya SSHA

**Eina:** `slappasswd`
```bash
# Dins del contenidor
docker exec -it extagram-s8-ldap slappasswd -h {SSHA}
```

**Procés:**
```
New password: ********
Re-enter new password: ********
{SSHA}hGRd8sP3F6K1m3N9z4L2vQ5xY7wE8rT9
```

**Actualitzar users.ldif:**
```ldif
userPassword: {SSHA}hGRd8sP3F6K1m3N9z4L2vQ5xY7wE8rT9
```

### Afegir Usuaris al Directori

**Opció 1: Amb volum Docker**

El fitxer `users.ldif` ja està muntat al contenidor i s'importa automàticament al iniciar.

**Opció 2: Manual**
```bash
docker exec -it extagram-s8-ldap ldapadd -x -D "cn=admin,dc=extagram,dc=local" -W -f /container/service/slapd/assets/config/bootstrap/ldif/custom/users.ldif
```

**Entrada de contrasenya:**
```
Enter LDAP Password: [admin_password_secure]
adding new entry "ou=users,dc=extagram,dc=local"
adding new entry "cn=hamza,ou=users,dc=extagram,dc=local"
adding new entry "cn=kevin,ou=users,dc=extagram,dc=local"
```

---

## Integració amb Aplicació

### Configuració PHP LDAP

**Instal·lar extensió LDAP:**

**Dockerfile (S2/S3):**
```dockerfile
FROM php:8.2-fpm-alpine

RUN apk add --no-cache \
    openldap-dev \
    && docker-php-ext-install ldap
```

**Reconstruir imatge:**
```bash
docker compose build s2-php s3-php
docker compose up -d s2-php s3-php
```

### Codi PHP: login_ldap.php

**Arxiu:** `s2-php/login_ldap.php`
```php
<?php
// Configuració LDAP
$ldap_host = "s8-ldap";  // Nom del servei Docker
$ldap_port = 389;
$base_dn = "ou=users,dc=extagram,dc=local";

// Connectar al servidor LDAP
$ldap_conn = ldap_connect($ldap_host, $ldap_port);

if (!$ldap_conn) {
    die("No es pot connectar al servidor LDAP");
}

// Configurar opcions LDAP
ldap_set_option($ldap_conn, LDAP_OPT_PROTOCOL_VERSION, 3);
ldap_set_option($ldap_conn, LDAP_OPT_REFERRALS, 0);

// Dades del formulari
$username = $_POST['username'] ?? '';
$password = $_POST['password'] ?? '';

// DN de l'usuari
$user_dn = "cn=$username,$base_dn";

// Intentar bind (autenticació)
if (@ldap_bind($ldap_conn, $user_dn, $password)) {
    // Autenticació exitosa
    
    // Obtenir informació de l'usuari
    $search = ldap_search($ldap_conn, $base_dn, "(cn=$username)");
    $entries = ldap_get_entries($ldap_conn, $search);
    
    if ($entries['count'] > 0) {
        $user_info = $entries[0];
        
        // Desar a sessió
        session_start();
        $_SESSION['user_authenticated'] = true;
        $_SESSION['username'] = $username;
        $_SESSION['full_name'] = $user_info['givenname'][0] . ' ' . $user_info['sn'][0];
        $_SESSION['email'] = $user_info['mail'][0];
        
        echo "Benvingut, " . $_SESSION['full_name'] . "!";
        
        // Redirect a pàgina principal
        header("Location: extagram.php");
        exit;
    }
} else {
    // Autenticació fallida
    echo "Usuari o contrasenya incorrectes";
}

ldap_close($ldap_conn);
?>
```

### Formulari Login HTML
```html
<!DOCTYPE html>
<html lang="ca">
<head>
    <meta charset="UTF-8">
    <title>Login LDAP - Extagram</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 400px; margin: 50px auto; }
        input { width: 100%; padding: 10px; margin: 10px 0; }
        button { width: 100%; padding: 10px; background: #007bff; color: white; border: none; }
    </style>
</head>
<body>
    <h2>Login Extagram</h2>
    <form method="POST" action="login_ldap.php">
        <input type="text" name="username" placeholder="Usuari (hamza o kevin)" required>
        <input type="password" name="password" placeholder="Contrasenya" required>
        <button type="submit">Entrar</button>
    </form>
</body>
</html>
```

---

## Verificació LDAP

### 1. Verificar Servei Actiu
```bash
docker ps | grep ldap
# Esperat: extagram-s8-ldap amb estat UP
```

### 2. Provar Connexió
```bash
docker exec -it extagram-s8-ldap ldapwhoami -x -D "cn=admin,dc=extagram,dc=local" -W
```

**Sortida esperada:**
```
Enter LDAP Password: 
dn:cn=admin,dc=extagram,dc=local
```

### 3. Llistar Usuaris
```bash
docker exec -it extagram-s8-ldap ldapsearch -x -b "ou=users,dc=extagram,dc=local" -LLL
```

**Sortida esperada:**
```
dn: ou=users,dc=extagram,dc=local
objectClass: organizationalUnit
ou: users

dn: cn=hamza,ou=users,dc=extagram,dc=local
objectClass: inetOrgPerson
cn: hamza
sn: Tayibi
givenName: Hamza
uid: hamza

dn: cn=kevin,ou=users,dc=extagram,dc=local
objectClass: inetOrgPerson
cn: kevin
sn: Armada
givenName: Kevin
uid: kevin
```

### 4. Autenticació Usuari
```bash
docker exec -it extagram-s8-ldap ldapwhoami -x -D "cn=hamza,ou=users,dc=extagram,dc=local" -W
```

**Entrada de contrasenya:**
```
Enter LDAP Password: [contrasenya_hamza]
dn:cn=hamza,ou=users,dc=extagram,dc=local
```

### 5. Cercar per Atribut
```bash
# Cercar per email
docker exec -it extagram-s8-ldap ldapsearch -x -b "dc=extagram,dc=local" "(mail=hamza.tayibi@extagram.local)"

# Cercar per UID
docker exec -it extagram-s8-ldap ldapsearch -x -b "dc=extagram,dc=local" "(uid=kevin)"
```

---

## Troubleshooting

### Problema 1: "Invalid Credentials"

**Simptoma:**
```php
ldap_bind(): Unable to bind to server: Invalid credentials
```

**Solucions:**

**1. Verificar contrasenya:**
```bash
docker exec -it extagram-s8-ldap ldapwhoami -x -D "cn=hamza,ou=users,dc=extagram,dc=local" -W
```

**2. Verificar DN correcte:**
```bash
# DN incorrecte
cn=hamza,dc=extagram,dc=local  # ✗ Falta ou=users

# DN correcte
cn=hamza,ou=users,dc=extagram,dc=local  # ✓
```

**3. Regenerar contrasenya:**
```bash
docker exec -it extagram-s8-ldap slappasswd -h {SSHA}
# Actualitzar users.ldif i reimportar
```

### Problema 2: "Can't Contact LDAP Server"

**Simptoma:**
```php
ldap_connect(): Can't contact LDAP server
```

**Solucions:**

**1. Verificar contenidor actiu:**
```bash
docker ps | grep ldap
```

**2. Verificar xarxa Docker:**
```bash
docker exec extagram-s2-php ping s8-ldap
# Ha de respondre
```

**3. Verificar port 389 obert:**
```bash
docker exec extagram-s8-ldap netstat -tlnp | grep :389
```

### Problema 3: "No Such Object"

**Simptoma:**
```
ldap_search(): Search: No such object
```

**Solucions:**

**1. Verificar base DN:**
```bash
docker exec -it extagram-s8-ldap ldapsearch -x -b "dc=extagram,dc=local" -s base
```

**2. Verificar que usuaris existeixen:**
```bash
docker exec -it extagram-s8-ldap ldapsearch -x -b "ou=users,dc=extagram,dc=local"
```

**3. Reimportar users.ldif:**
```bash
docker compose down s8-ldap
docker volume rm docker_ldap-data
docker compose up -d s8-ldap
```

### Problema 4: PHP Extension LDAP Missing

**Simptoma:**
```
Fatal error: Call to undefined function ldap_connect()
```

**Solució:**

**Verificar extensió instal·lada:**
```bash
docker exec extagram-s2-php php -m | grep ldap
# Ha de mostrar: ldap
```

**Si no està:**
```bash
# Reconstruir imatge amb LDAP
docker compose build s2-php
docker compose up -d s2-php
```

---

## Comandes Útils LDAP

### Afegir Entrada
```bash
ldapadd -x -D "cn=admin,dc=extagram,dc=local" -W -f new_user.ldif
```

### Modificar Entrada
```bash
ldapmodify -x -D "cn=admin,dc=extagram,dc=local" -W -f modify_user.ldif
```

**Exemple modify_user.ldif:**
```ldif
dn: cn=hamza,ou=users,dc=extagram,dc=local
changetype: modify
replace: mail
mail: hamza.new@extagram.local
```

### Eliminar Entrada
```bash
ldapdelete -x -D "cn=admin,dc=extagram,dc=local" -W "cn=hamza,ou=users,dc=extagram,dc=local"
```

### Canviar Contrasenya
```bash
ldappasswd -x -D "cn=admin,dc=extagram,dc=local" -W -S "cn=hamza,ou=users,dc=extagram,dc=local"
```

---

## Millors Pràctiques

1. **Contrasenyes SSHA** - Sempre encriptar contrasenyes amb {SSHA}
2. **Xarxa internal** - S8 a `extagram_data` (NO accessible des d'Internet)
3. **LDAPS** - Utilitzar TLS/SSL per connexions en producció
4. **Backups regulars** - Exportar directori LDAP periòdicament
5. **Auditoria** - Activar logging de totes les operacions LDAP
6. **ACLs** - Definir permisos granulars per objectes

---

**Document elaborat per:** Hamza  
**Data:** 10 de Març de 2026  
**Versió:** 1.0
