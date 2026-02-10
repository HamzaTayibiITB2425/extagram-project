#!/bin/bash
echo "📊 MySQL Logs - Solo comandos SQL (sin BLOB)"
echo "============================================="
docker compose logs -f s7-database 2>&1 | \
  stdbuf -oL tr -cd '\11\12\15\40-\176' | \
  grep --line-buffered -E "(Connect|Query|INSERT|SELECT|UPDATE|DELETE|Prepare|Execute|Close)" | \
  sed 's/_binary.*$/<BLOB_OMITIDO>/' | \
  grep -v "^$"
