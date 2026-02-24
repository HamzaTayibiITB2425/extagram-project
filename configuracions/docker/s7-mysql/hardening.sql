-- Eliminar usuarios anónimos
DELETE FROM mysql.user WHERE User='';

-- Eliminar base de datos test
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

-- Restringir acceso remoto de root (SOLO localhost)
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

-- Crear usuario monitor (solo lectura)
CREATE USER IF NOT EXISTS 'monitor'@'%' IDENTIFIED BY 'MonitorPass2026!';
GRANT SELECT, PROCESS, REPLICATION CLIENT ON *.* TO 'monitor'@'%';

-- Limitar privilegios extagram_admin (SOLO lo necesario)
REVOKE ALL PRIVILEGES ON *.* FROM 'extagram_admin'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON extagram_db.* TO 'extagram_admin'@'%';

FLUSH PRIVILEGES;
