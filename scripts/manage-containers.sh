#!/bin/bash

# Script para gestionar contenedores de herramientas de seguridad
# Uso: ./scripts/manage-containers.sh [start|stop|restart|status|logs|clean]

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar ayuda
show_help() {
    echo -e "${BLUE}SecOps MCP - Gestor de Contenedores${NC}"
    echo ""
    echo "Uso: $0 [COMANDO]"
    echo ""
    echo "Comandos disponibles:"
    echo "  start     - Iniciar todos los contenedores"
    echo "  stop      - Detener todos los contenedores"
    echo "  restart   - Reiniciar todos los contenedores"
    echo "  status    - Mostrar estado de los contenedores"
    echo "  logs      - Mostrar logs de un contenedor específico"
    echo "  clean     - Limpiar contenedores y volúmenes"
    echo "  health    - Verificar salud de los servicios"
    echo "  update    - Actualizar imágenes de Docker"
    echo "  help      - Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  $0 start                    # Iniciar todos los servicios"
    echo "  $0 logs nuclei              # Ver logs de Nuclei"
    echo "  $0 status                   # Estado de todos los servicios"
}

# Función para iniciar servicios
start_services() {
    echo -e "${GREEN}🚀 Iniciando servicios SecOps MCP...${NC}"
    
    # Verificar que Docker esté ejecutándose
    if ! docker info > /dev/null 2>&1; then
        echo -e "${RED}❌ Docker no está ejecutándose${NC}"
        exit 1
    fi
    
    # Iniciar servicios
    docker-compose up -d
    
    echo -e "${GREEN}✅ Servicios iniciados correctamente${NC}"
    echo ""
    echo -e "${BLUE}📊 Servicios disponibles:${NC}"
    echo "  🔒 SecOps MCP: http://localhost:8080"
    echo "  🚨 Nuclei:     http://localhost:8081 (projectdiscovery/nuclei:latest)"
    echo "  🔍 FFUF:       http://localhost:8082 (trickest/ffuf:latest)"
    echo "  🌐 Nmap:       http://localhost:8083 (uzyexe/nmap:latest)"
    echo "  💉 SQLMap:     http://localhost:8084 (googlesky/sqlmap:latest)"
    echo "  📝 WPScan:     http://localhost:8085 (wpscanteam/wpscan:latest)"
    echo "  🗺️  Amass:      http://localhost:8086 (securecodebox/amass:latest)"
    echo "  🔐 Hashcat:    http://localhost:8087 (javydekoning/hashcat:latest)"
    echo "  🌍 HTTPX:      http://localhost:8088 (projectdiscovery/httpx:latest)"
    echo "  🔎 Subfinder:  http://localhost:8089 (projectdiscovery/subfinder:latest)"
    echo "  🔒 TLSX:       http://localhost:8090 (projectdiscovery/tlsx:latest)"
}

# Función para detener servicios
stop_services() {
    echo -e "${YELLOW}🛑 Deteniendo servicios SecOps MCP...${NC}"
    docker-compose down
    echo -e "${GREEN}✅ Servicios detenidos correctamente${NC}"
}

# Función para reiniciar servicios
restart_services() {
    echo -e "${YELLOW}🔄 Reiniciando servicios SecOps MCP...${NC}"
    docker-compose restart
    echo -e "${GREEN}✅ Servicios reiniciados correctamente${NC}"
}

# Función para mostrar estado
show_status() {
    echo -e "${BLUE}📊 Estado de los servicios SecOps MCP:${NC}"
    echo ""
    docker-compose ps
    echo ""
    
    # Mostrar uso de recursos
    echo -e "${BLUE}💾 Uso de recursos:${NC}"
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
}

# Función para mostrar logs
show_logs() {
    if [ -z "$2" ]; then
        echo -e "${RED}❌ Especifica un servicio para ver sus logs${NC}"
        echo "Uso: $0 logs [servicio]"
        echo "Servicios disponibles: nuclei, ffuf, nmap, sqlmap, wpscan, amass, hashcat, httpx, subfinder, tlsx"
        exit 1
    fi
    
    SERVICE=$2
    echo -e "${BLUE}📋 Mostrando logs de $SERVICE:${NC}"
    docker-compose logs -f $SERVICE
}

# Función para limpiar
clean_services() {
    echo -e "${YELLOW}🧹 Limpiando contenedores y volúmenes...${NC}"
    
    read -p "¿Estás seguro de que quieres eliminar todos los contenedores y volúmenes? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker-compose down -v --remove-orphans
        docker system prune -f
        echo -e "${GREEN}✅ Limpieza completada${NC}"
    else
        echo -e "${YELLOW}❌ Limpieza cancelada${NC}"
    fi
}

# Función para verificar salud
check_health() {
    echo -e "${BLUE}🏥 Verificando salud de los servicios...${NC}"
    echo ""
    
    SERVICES=("nuclei" "ffuf" "nmap" "sqlmap" "wpscan" "amass" "hashcat" "httpx" "subfinder" "tlsx")
    
    for service in "${SERVICES[@]}"; do
        PORT=$(docker-compose port $service 8080 | cut -d: -f2)
        if [ ! -z "$PORT" ]; then
            if curl -s "http://localhost:$PORT/health" > /dev/null 2>&1; then
                echo -e "  ✅ $service: http://localhost:$PORT (SALUDABLE)"
            else
                echo -e "  ❌ $service: http://localhost:$PORT (NO RESPONDE)"
            fi
        else
            echo -e "  ⚠️  $service: Puerto no disponible"
        fi
    done
}

# Función para actualizar imágenes
update_images() {
    echo -e "${BLUE}🔄 Actualizando imágenes de Docker...${NC}"
    
    # Actualizar todas las imágenes
    docker-compose pull
    
    echo -e "${GREEN}✅ Imágenes actualizadas${NC}"
    echo ""
    echo -e "${YELLOW}💡 Para aplicar las actualizaciones, reinicia los servicios:${NC}"
    echo "  $0 restart"
}

# Función principal
main() {
    case "${1:-help}" in
        start)
            start_services
            ;;
        stop)
            stop_services
            ;;
        restart)
            restart_services
            ;;
        status)
            show_status
            ;;
        logs)
            show_logs "$@"
            ;;
        clean)
            clean_services
            ;;
        health)
            check_health
            ;;
        update)
            update_images
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            echo -e "${RED}❌ Comando desconocido: $1${NC}"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# Ejecutar función principal
main "$@" 