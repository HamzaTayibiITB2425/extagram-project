# Comandos Útiles

## Atajos Rápidos
```bash
cd ansible/

# Verificar todo
./scripts/shortcuts.sh verify

# Ver logs
./scripts/shortcuts.sh logs extagram-grafana

# Reiniciar servicio
./scripts/shortcuts.sh restart s1-loadbalancer

# Ver estado
./scripts/shortcuts.sh status
```

## Comandos Ansible Directos

### Información del Sistema
```bash
# Ver uptime
ansible extagram-server -i inventory.yml -m shell -a "uptime"

# Ver uso de disco
ansible extagram-server -i inventory.yml -m shell -a "df -h"

# Ver memoria
ansible extagram-server -i inventory.yml -m shell -a "free -h"

# Ver procesos
ansible extagram-server -i inventory.yml -m shell -a "ps aux | head -20"
```

### Docker
```bash
# Ver contenedores
ansible extagram-server -i inventory.yml -m shell -a "docker ps"

# Ver stats
ansible extagram-server -i inventory.yml -m shell -a "docker stats --no-stream"

# Logs específicos
ansible extagram-server -i inventory.yml -m shell -a "docker logs extagram-grafana --tail 100"

# Reiniciar contenedor
ansible extagram-server -i inventory.yml -m shell -a "docker restart extagram-s1-loadbalancer"
```

### Logs del Sistema
```bash
# Ver logs de systemd
ansible extagram-server -i inventory.yml -m shell -a "journalctl -u extagram-grafana-init -n 50"

# Ver logs del sistema
ansible extagram-server -i inventory.yml -m shell -a "journalctl -xe --no-pager | tail -50"

# Ver logs de NGINX
ansible extagram-server -i inventory.yml -m shell -a "docker logs extagram-s1-loadbalancer --tail 100"
```

### Certificados SSL
```bash
# Ver certificados
ansible extagram-server -i inventory.yml -m shell -a "certbot certificates"

# Renovar manualmente
ansible extagram-server -i inventory.yml -m shell -a "certbot renew --dry-run"
```
