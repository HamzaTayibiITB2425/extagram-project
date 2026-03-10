#!/bin/bash
# Atajos rápidos para Ansible

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ANSIBLE_DIR="$(dirname "$SCRIPT_DIR")"
INVENTORY="$ANSIBLE_DIR/inventory.yml"
HOST="extagram-server"

case "$1" in
  verify)
    ansible-playbook -i $INVENTORY $ANSIBLE_DIR/playbooks/deploy-full.yml --tags verify
    ;;
  
  logs)
    CONTAINER="${2:-extagram-grafana}"
    ansible $HOST -i $INVENTORY -m shell -a "docker logs $CONTAINER --tail 50"
    ;;
  
  restart)
    CONTAINER="${2:-s1-loadbalancer}"
    ansible $HOST -i $INVENTORY -m shell -a "docker compose -f /home/ubuntu/extagram-project/configuracions/docker/docker-compose.yml restart $CONTAINER"
    ;;
  
  status)
    ansible $HOST -i $INVENTORY -m shell -a "docker ps --format 'table {{.Names}}\t{{.Status}}'"
    ;;
  
  deploy)
    ansible-playbook -i $INVENTORY $ANSIBLE_DIR/playbooks/deploy-full.yml
    ;;
  
  *)
    echo "🚀 Atajos Ansible - Extagram"
    echo ""
    echo "Uso: $0 {comando} [opciones]"
    echo ""
    echo "Comandos:"
    echo "  verify                       Verificar estado del sistema"
    echo "  logs [contenedor]           Ver logs (default: extagram-grafana)"
    echo "  restart [contenedor]        Reiniciar contenedor (default: s1-loadbalancer)"
    echo "  status                      Ver estado de contenedores"
    echo "  deploy                      Despliegue completo"
    echo ""
    echo "Ejemplos:"
    echo "  $0 verify"
    echo "  $0 logs extagram-prometheus"
    echo "  $0 restart grafana"
    echo "  $0 status"
    ;;
esac
