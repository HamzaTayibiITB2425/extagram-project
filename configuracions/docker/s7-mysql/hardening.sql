-- ============================================
-- HARDENING MySQL - Extagram Database
-- Sprint 4: Seguridad
-- Fecha: 23/02/2026
-- ============================================

USE mysql;

-- 1. ELIMINAR USUARIOS ANÓNIMOS
DELETE FROM mysql.user WHERE User='';

-- 2. ELIMINAR BASE DE DATOS TEST
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

-- 3. RESTRINGIR ACCESO REMOTO DE ROOT
-- Root solo puede acceder desde localhost
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

-- 4. CREAR USUARIO MONITOR (SOLO LECTURA)
-- Usuario para monitoreo sin permisos de escritura
CREATE USER IF NOT EXISTS 'monitor'@'%' IDENTIFIED BY 'MonitorPass2026!';
GRANT SELECT, PROCESS, REPLICATION CLIENT ON *.* TO 'monitor'@'%';

-- 5. LIMITAR PRIVILEGIOS EXTAGRAM_ADMIN
-- Revocar todos los privilegios globales
REVOKE ALL PRIVILEGES ON *.* FROM 'extagram_admin'@'%';

-- Dar SOLO los privilegios necesarios en la base de datos extagram_db
GRANT SELECT, INSERT, UPDATE, DELETE ON extagram_db.* TO 'extagram_admin'@'%';

-- NO dar privilegios de: CREATE, DROP, ALTER, INDEX, GRANT, etc.

-- 6. APLICAR CAMBIOS
FLUSH PRIVILEGES;

-- 7. MOSTRAR USUARIOS FINALES (Para logs de verificación)
SELECT 
    User, 
    Host, 
    IF(LENGTH(authentication_string) > 0, 'YES', 'NO') AS Has_Password,
    plugin 
FROM mysql.user 
WHERE User NOT IN ('mysql.sys', 'mysql.session', 'mysql.infoschema')
ORDER BY User, Host;

-- Fin del hardening
