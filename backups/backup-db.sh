#!/bin/bash
# Backup automático MySQL Extagram
BACKUP_DIR="/home/ubuntu/extagram-project/backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="extagram_db_${DATE}.sql"

echo "[$(date)] Iniciando backup..."

# Crear backup
docker exec extagram-s7-database mysqldump \
  -u root -prootpass123 \
  --single-transaction \
  --routines \
  --triggers \
  extagram_db \
  > "${BACKUP_DIR}/${BACKUP_FILE}"

# Comprimir
gzip "${BACKUP_DIR}/${BACKUP_FILE}"

# Limpiar backups antiguos (mantener 7 días)
find "${BACKUP_DIR}" -name "extagram_db_*.sql.gz" -mtime +7 -delete

echo "[$(date)] Backup completado: ${BACKUP_FILE}.gz"
ls -lh "${BACKUP_DIR}/${BACKUP_FILE}.gz"
