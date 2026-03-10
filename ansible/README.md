# Automatización Extagram con Ansible

Despliegue automatizado completo del proyecto Extagram usando Ansible.

## 📋 Requisitos Previos

### Control Node (tu máquina local)
- Ansible instalado
- Acceso SSH al servidor

### Managed Node (servidor destino)
- Ubuntu 24.04 LTS
- Acceso root/sudo
- Puertos abiertos: 80, 443, 22

## 🚀 Instalación Rápida

### 1. Preparar Control Node
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install ansible -y

# macOS
brew install ansible
```

### 2. Configurar Acceso SSH
```bash
# Generar clave SSH en el servidor destino
ssh usuario@servidor
ssh-keygen -t ed25519 -f ~/.ssh/ansible_key -N ""
cat ~/.ssh/ansible_key.pub >> ~/.ssh/authorized_keys
cat ~/.ssh/ansible_key  # Copiar esta clave
exit

# En tu máquina local, guardar clave
nano ~/ansible_extagram.pem
# Pegar la clave completa
chmod 600 ~/ansible_extagram.pem
```

### 3. Configurar Inventario
```bash
# Editar el inventario
nano inventory.yml

# Cambiar:
# - ansible_host: TU_DOMINIO_O_IP
# - ansible_ssh_private_key_file: RUTA_A_TU_CLAVE
```

### 4. Probar Conexión
```bash
ansible all -i inventory.yml -m ping
```

### 5. Desplegar
```bash
# Despliegue completo
ansible-playbook -i inventory.yml playbooks/deploy-full.yml

# Solo verificación
ansible-playbook -i inventory.yml playbooks/deploy-full.yml --tags verify
```

## 📚 Documentación

- [Guía de Instalación](docs/INSTALL.md)
- [Comandos Útiles](docs/COMMANDS.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)

## 🎯 Estructura del Proyecto
```
ansible/
├── README.md                    # Este archivo
├── inventory.yml                # Inventario de servidores
├── playbooks/
│   ├── deploy-full.yml         # Despliegue completo
│   └── verify.yml              # Solo verificación
├── scripts/
│   └── shortcuts.sh            # Comandos rápidos
└── docs/
    ├── INSTALL.md              # Guía instalación
    ├── COMMANDS.md             # Comandos útiles
    └── TROUBLESHOOTING.md      # Solución problemas
```

## 🔗 URLs del Proyecto

- **Aplicación:** https://extagram-grup3.duckdns.org/extagram.php
- **Grafana:** https://extagram-grup3.duckdns.org/grafana/
- **Prometheus:** https://extagram-grup3.duckdns.org/prometheus/
- **cAdvisor:** https://extagram-grup3.duckdns.org/cadvisor/

## 👥 Autor

Hamza - ASIX2c ITB Barcelona
