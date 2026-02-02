#!/bin/bash
# Restaurar base de datos desde backup

if [ -z "$1" ]; then
    echo "Uso: ./restore-db.sh <archivo_backup.sql.gz>"
    echo ""
    echo "Backups disponibles:"
    ls -lht /home/ubuntu/extagram-project/backups/*.sql.gz 2>/dev/null | head -10
    exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
    echo "Error: Archivo no encontrado: $BACKUP_FILE"
    exit 1
fi

echo "ADVERTENCIA: Esto sobrescribirá la base de datos actual"
read -p "¿Continuar? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Operación cancelada"
    exit 0
fi

echo "Restaurando desde: $BACKUP_FILE"

# Descomprimir y restaurar
gunzip -c "$BACKUP_FILE" | docker exec -i extagram-s7-database mysql \
  -u root -prootpass123 extagram_db

echo "Base de datos restaurada exitosamente"
