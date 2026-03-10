# Troubleshooting

## Problemas Comunes

### Error: "Permission denied (publickey)"

**Causa:** Clave SSH incorrecta o permisos mal configurados.

**Solución:**
```bash
# Verificar permisos
chmod 600 ~/ansible_extagram.pem

# Probar conexión manual
ssh -i ~/ansible_extagram.pem ubuntu@extagram-grup3.duckdns.org

# Verificar que la clave está completa
cat ~/ansible_extagram.pem
# Debe empezar con -----BEGIN y terminar con -----END
```

### Error: "Host key verification failed"

**Causa:** Primera conexión al servidor.

**Solución:**
```bash
# Conectar manualmente una vez
ssh -i ~/ansible_extagram.pem ubuntu@extagram-grup3.duckdns.org
# Escribir "yes"
exit

# O agregar al inventory.yml:
ansible_ssh_common_args: '-o StrictHostKeyChecking=no'
```

### Contenedores no se inician

**Verificar:**
```bash
ansible extagram-server -i inventory.yml -m shell -a "docker logs NOMBRE_CONTENEDOR"
ansible extagram-server -i inventory.yml -m shell -a "docker compose -f /home/ubuntu/extagram-project/configuracions/docker/docker-compose.yml ps"
```

### Grafana no muestra datos

**Verificar:**
```bash
# Prometheus
ansible extagram-server -i inventory.yml -m shell -a "docker logs extagram-prometheus --tail 50"

# Loki
ansible extagram-server -i inventory.yml -m shell -a "docker logs extagram-loki --tail 50"

# Promtail
ansible extagram-server -i inventory.yml -m shell -a "docker logs extagram-promtail --tail 50"
```

### SSL no válido

**Verificar:**
```bash
ansible extagram-server -i inventory.yml -m shell -a "certbot certificates"
ansible extagram-server -i inventory.yml -m shell -a "ls -la /etc/letsencrypt/live/extagram-grup3.duckdns.org/"
```

## Comandos de Depuración
```bash
# Ver variables de Ansible
ansible-inventory -i inventory.yml --list

# Ejecutar en modo verbose
ansible-playbook -i inventory.yml playbooks/deploy-full.yml -vvv

# Modo dry-run
ansible-playbook -i inventory.yml playbooks/deploy-full.yml --check
```
