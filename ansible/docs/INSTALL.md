# Guía de Instalación

## Preparación del Entorno

### 1. Instalar Ansible (Control Node)

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install ansible -y
ansible --version
```

**macOS:**
```bash
brew install ansible
ansible --version
```

### 2. Configurar SSH

**En el servidor destino:**
```bash
ssh usuario@servidor
ssh-keygen -t ed25519 -f ~/.ssh/ansible_key -N ""
cat ~/.ssh/ansible_key.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/ansible_key
chmod 644 ~/.ssh/ansible_key.pub
cat ~/.ssh/ansible_key
# Copiar TODA la salida
```

**En tu máquina local:**
```bash
nano ~/ansible_extagram.pem
# Pegar la clave completa desde -----BEGIN hasta -----END
chmod 600 ~/ansible_extagram.pem
```

### 3. Configurar Inventario
```bash
cd ansible/
nano inventory.yml
```

Modificar:
- `ansible_host`: Tu dominio o IP
- `ansible_ssh_private_key_file`: Ruta a tu clave
- `domain_name`: Tu dominio
- `email_ssl`: Tu email para SSL

### 4. Probar Conexión
```bash
ansible all -i inventory.yml -m ping
```

Deberías ver:
```
extagram-server | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

## Despliegue

### Despliegue Completo
```bash
ansible-playbook -i inventory.yml playbooks/deploy-full.yml
```

### Solo Verificación
```bash
ansible-playbook -i inventory.yml playbooks/deploy-full.yml --tags verify
```

### Por Etapas
```bash
# Solo instalar Docker
ansible-playbook -i inventory.yml playbooks/deploy-full.yml --tags docker

# Solo verificar SSL
ansible-playbook -i inventory.yml playbooks/deploy-full.yml --tags ssl
```
