#!/bin/bash
# Iniciar OpenLDAP en background
/container/tool/run &

# Esperar a que slapd esté listo
echo "[LDAP] Esperando servidor..."
for i in $(seq 1 20); do
  if ldapsearch -x -H ldap://localhost \
    -D "cn=admin,dc=extagram,dc=com" \
    -w rootpass123 \
    -b "dc=extagram,dc=com" > /dev/null 2>&1; then
    echo "[LDAP] Servidor listo"
    break
  fi
  sleep 2
done

# Generar hash de contraseña para usuarios
USER_PASS_HASH=$(slappasswd -s "${LDAP_USER_PASSWORD:-@ITB2026}")

# Importar solo si no existen
if ! ldapsearch -x -H ldap://localhost \
  -D "cn=admin,dc=extagram,dc=com" \
  -w rootpass123 \
  -b "dc=extagram,dc=com" "(cn=Hamza)" | grep -q "dn:"; then
  
  # Crear Hamza.ldif dinámicamente
  cat > /tmp/Hamza_dynamic.ldif << HAMZA
dn: cn=Hamza,dc=extagram,dc=com
objectClass: inetOrgPerson
cn: Hamza
sn: usuario
userPassword: ${USER_PASS_HASH}
HAMZA
  
  # Crear Kevin.ldif dinámicamente
  cat > /tmp/Kevin_dynamic.ldif << KEVIN
dn: cn=Kevin,dc=extagram,dc=com
objectClass: inetOrgPerson
cn: Kevin
sn: usuario
userPassword: ${USER_PASS_HASH}
KEVIN
  
  echo "[LDAP] Importando Hamza..."
  ldapadd -x -H ldap://localhost -D "cn=admin,dc=extagram,dc=com" -w rootpass123 -f /tmp/Hamza_dynamic.ldif
  echo "[LDAP] Importando Kevin..."
  ldapadd -x -H ldap://localhost -D "cn=admin,dc=extagram,dc=com" -w rootpass123 -f /tmp/Kevin_dynamic.ldif
  echo "[LDAP] Usuarios importados"
else
  echo "[LDAP] Usuarios ya existen"
fi

# Mantener contenedor vivo
wait
