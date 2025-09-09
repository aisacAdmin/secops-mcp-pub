#!/bin/bash

# Script de instalación para VPS - SecOps MCP
# Este script instala y configura el servidor MCP en el VPS

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔒 SecOps MCP - Instalación en VPS${NC}"
echo "================================================"

# Verificar si es root
if [[ $EUID -eq 0 ]]; then
   echo -e "${RED}❌ Este script no debe ejecutarse como root${NC}"
   echo "Ejecuta: sudo -u $SUDO_USER $0"
   exit 1
fi

# Función para mostrar ayuda
show_help() {
    echo -e "${BLUE}SecOps MCP - Instalador para VPS${NC}"
    echo ""
    echo "Uso: $0 [OPCIÓN]"
    echo ""
    echo "Opciones:"
    echo "  install     - Instalación completa (recomendado)"
    echo "  python      - Solo instalar Python y dependencias"
    echo "  docker      - Solo instalar Docker y contenedores"
    echo "  systemd     - Solo configurar servicio systemd"
    echo "  help        - Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  $0 install                    # Instalación completa"
    echo "  $0 python                     # Solo Python"
    echo "  $0 docker                     # Solo Docker"
}

# Función para instalar Python y dependencias
install_python() {
    echo -e "${BLUE}🐍 Instalando Python y dependencias...${NC}"
    
    # Verificar sistema operativo
    if [[ -f /etc/debian_version ]]; then
        # Debian/Ubuntu
        echo "Sistema detectado: Debian/Ubuntu"
        sudo apt-get update
        sudo apt-get install -y python3 python3-pip python3-venv curl git
        
    elif [[ -f /etc/redhat-release ]]; then
        # CentOS/RHEL/Rocky
        echo "Sistema detectado: CentOS/RHEL/Rocky"
        sudo yum update -y
        sudo yum install -y python3 python3-pip python3-venv curl git
        
    elif [[ -f /etc/arch-release ]]; then
        # Arch Linux
        echo "Sistema detectado: Arch Linux"
        sudo pacman -Syu --noconfirm python python-pip python-virtualenv curl git
        
    else
        echo -e "${RED}❌ Sistema operativo no soportado${NC}"
        exit 1
    fi
    
    # Verificar Python
    python3 --version
    pip3 --version
    
    echo -e "${GREEN}✅ Python instalado correctamente${NC}"
}

# Función para instalar Docker
install_docker() {
    echo -e "${BLUE}🐳 Instalando Docker...${NC}"
    
    # Verificar si Docker ya está instalado
    if command -v docker &> /dev/null; then
        echo "Docker ya está instalado"
        docker --version
    else
        # Instalar Docker
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
        rm get-docker.sh
        
        echo -e "${YELLOW}⚠️  Reinicia la sesión para que los cambios de grupo surtan efecto${NC}"
    fi
    
    # Verificar Docker Compose
    if command -v docker-compose &> /dev/null; then
        echo "Docker Compose ya está instalado"
        docker-compose --version
    else
        # Instalar Docker Compose
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        docker-compose --version
    fi
    
    echo -e "${GREEN}✅ Docker instalado correctamente${NC}"
}

# Función para configurar el proyecto
setup_project() {
    echo -e "${BLUE}📁 Configurando proyecto SecOps MCP...${NC}"
    
    # Crear directorios de datos
    mkdir -p data/{nuclei,ffuf,sqlmap,wpscan,amass,hashcat,httpx,subfinder,tlsx}/{templates,config,wordlists,output,hashes}
    
    # Crear entorno virtual
    python3 -m venv .venv
    source .venv/bin/activate
    
    # Instalar dependencias Python
    pip install --upgrade pip
    pip install -e .
    
    echo -e "${GREEN}✅ Proyecto configurado correctamente${NC}"
}

# Función para configurar systemd
setup_systemd() {
    echo -e "${BLUE}⚙️  Configurando servicio systemd...${NC}"
    
    # Crear usuario de servicio si no existe
    if ! id "secops" &>/dev/null; then
        sudo useradd -r -s /bin/false -d /opt/secops-mcp secops
        echo -e "${GREEN}✅ Usuario 'secops' creado${NC}"
    fi
    
    # Crear directorio de instalación
    sudo mkdir -p /opt/secops-mcp
    sudo chown secops:secops /opt/secops-mcp
    
    # Copiar archivos del proyecto
    sudo cp -r . /opt/secops-mcp/
    sudo chown -R secops:secops /opt/secops-mcp/
    
    # Crear archivo de servicio systemd
    sudo tee /etc/systemd/system/secops-mcp.service > /dev/null <<EOF
[Unit]
Description=SecOps MCP Server
After=network.target docker.service
Requires=docker.service

[Service]
Type=simple
User=secops
Group=secops
WorkingDirectory=/opt/secops-mcp
Environment=PATH=/opt/secops-mcp/.venv/bin
ExecStart=/opt/secops-mcp/.venv/bin/python main.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
    
    # Recargar systemd y habilitar servicio
    sudo systemctl daemon-reload
    sudo systemctl enable secops-mcp.service
    
    echo -e "${GREEN}✅ Servicio systemd configurado${NC}"
    echo -e "${YELLOW}💡 Para iniciar el servicio: sudo systemctl start secops-mcp${NC}"
}

# Función para verificar instalación
verify_installation() {
    echo -e "${BLUE}🔍 Verificando instalación...${NC}"
    
    # Verificar Python
    if command -v python3 &> /dev/null; then
        echo -e "✅ Python3: $(python3 --version)"
    else
        echo -e "❌ Python3: No instalado"
    fi
    
    # Verificar Docker
    if command -v docker &> /dev/null; then
        echo -e "✅ Docker: $(docker --version)"
    else
        echo -e "❌ Docker: No instalado"
    fi
    
    # Verificar Docker Compose
    if command -v docker-compose &> /dev/null; then
        echo -e "✅ Docker Compose: $(docker-compose --version)"
    else
        echo -e "❌ Docker Compose: No instalado"
    fi
    
    # Verificar servicio systemd
    if systemctl is-enabled secops-mcp.service &> /dev/null; then
        echo -e "✅ Servicio systemd: Habilitado"
    else
        echo -e "❌ Servicio systemd: No configurado"
    fi
    
    echo -e "${GREEN}✅ Verificación completada${NC}"
}

# Función de instalación completa
install_complete() {
    echo -e "${BLUE}🚀 Iniciando instalación completa...${NC}"
    
    install_python
    install_docker
    setup_project
    setup_systemd
    
    echo -e "${GREEN}🎉 Instalación completa finalizada!${NC}"
    echo ""
    echo -e "${BLUE}📋 Próximos pasos:${NC}"
    echo "1. Reinicia la sesión para que Docker funcione:"
    echo "   exit && ssh usuario@vps"
    echo ""
    echo "2. Inicia los contenedores Docker:"
    echo "   docker-compose up -d"
    echo ""
    echo "3. Inicia el servicio MCP:"
    echo "   sudo systemctl start secops-mcp"
    echo ""
    echo "4. Verifica el estado:"
    echo "   sudo systemctl status secops-mcp"
    echo "   curl http://localhost:8080/health"
    echo ""
    echo -e "${YELLOW}💡 El servidor MCP estará disponible en: http://localhost:8080${NC}"
}

# Función principal
main() {
    case "${1:-help}" in
        install)
            install_complete
            ;;
        python)
            install_python
            ;;
        docker)
            install_docker
            ;;
        systemd)
            setup_systemd
            ;;
        verify)
            verify_installation
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            echo -e "${RED}❌ Opción desconocida: $1${NC}"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# Ejecutar función principal
main "$@" 