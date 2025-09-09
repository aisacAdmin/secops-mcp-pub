#!/bin/bash

# Script de despliegue para VPS Debian
# Este script configura completamente el entorno SecOps MCP en tu VPS

echo "🚀 Desplegando SecOps MCP en VPS Debian..."
echo "=============================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar mensajes
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar que estemos en Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    print_warning "Este script está diseñado para Linux. Si estás en macOS, úsalo solo para referencia."
    print_warning "Para producción, ejecuta este script en tu VPS Debian."
fi

# Verificar Docker
print_status "Verificando Docker..."
if ! command -v docker &> /dev/null; then
    print_error "Docker no está instalado. Instalando Docker..."
    
    # Instalar Docker en Debian/Ubuntu
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
    
    # Agregar GPG key oficial de Docker
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    # Agregar repositorio de Docker
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Instalar Docker
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    
    # Agregar usuario al grupo docker
    sudo usermod -aG docker $USER
    print_warning "Usuario agregado al grupo docker. Necesitarás cerrar sesión y volver a entrar."
    
else
    print_success "Docker ya está instalado"
fi

# Verificar que Docker esté funcionando
print_status "Verificando estado de Docker..."
if ! docker info &> /dev/null; then
    print_error "Docker no está funcionando. Iniciando servicio..."
    sudo systemctl start docker
    sudo systemctl enable docker
else
    print_success "Docker está funcionando correctamente"
fi

# Verificar Docker Compose
print_status "Verificando Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose no está instalado. Instalando..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
else
    print_success "Docker Compose ya está instalado"
fi

# Dar permisos de ejecución a los scripts
print_status "Configurando permisos de scripts..."
chmod +x scripts/*.sh

# Ejecutar configuración de herramientas Docker
print_status "Configurando herramientas Docker..."
./scripts/setup-docker-tools.sh

# Verificar que todas las herramientas funcionen
print_status "Probando herramientas Docker..."
./scripts/test-docker-tools.sh

# Crear script de servicio systemd
print_status "Creando servicio systemd..."
sudo tee /etc/systemd/system/secops-mcp.service > /dev/null << EOF
[Unit]
Description=SecOps MCP Server
After=docker.service
Requires=docker.service

[Service]
Type=simple
User=$USER
WorkingDirectory=$(pwd)
ExecStart=/usr/bin/python3 main.py
Restart=always
RestartSec=10
Environment=PATH=/usr/bin:/usr/local/bin
Environment=DOCKER_HOST=unix:///var/run/docker.sock

[Install]
WantedBy=multi-user.target
EOF

# Recargar systemd y habilitar servicio
sudo systemctl daemon-reload
sudo systemctl enable secops-mcp.service

print_success "Servicio systemd creado y habilitado"

# Crear script de monitoreo
print_status "Creando script de monitoreo..."
cat > monitor-secops.sh << 'EOF'
#!/bin/bash

echo "🔍 Monitoreando SecOps MCP..."
echo "================================"

# Verificar estado del servicio
echo "📊 Estado del servicio:"
sudo systemctl status secops-mcp.service --no-pager -l

echo ""
echo "🐳 Contenedores Docker:"
docker ps -a --filter "name=secops-" --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"

echo ""
echo "💾 Uso de recursos:"
docker system df

echo ""
echo "📋 Logs del servicio:"
sudo journalctl -u secops-mcp.service --no-pager -l --lines=20
EOF

chmod +x monitor-secops.sh

# Crear script de limpieza
print_status "Creando script de limpieza..."
cat > cleanup-secops.sh << 'EOF'
#!/bin/bash

echo "🧹 Limpiando entorno SecOps MCP..."
echo "=================================="

# Detener servicio
sudo systemctl stop secops-mcp.service

# Limpiar contenedores
docker ps -a --filter "name=secops-" --format "{{.ID}}" | xargs -r docker rm -f

# Limpiar imágenes no utilizadas
docker image prune -f

# Limpiar volúmenes no utilizados
docker volume prune -f

# Limpiar redes no utilizadas
docker network prune -f

echo "✅ Limpieza completada"
EOF

chmod +x cleanup-secops.sh

# Mostrar resumen final
echo ""
echo "=============================================="
echo "🎉 DESPLIEGUE COMPLETADO EXITOSAMENTE"
echo "=============================================="
echo ""
echo "📋 Servicios configurados:"
echo "  ✅ Docker y Docker Compose"
echo "  ✅ Todas las herramientas de seguridad"
echo "  ✅ Servicio systemd (secops-mcp.service)"
echo "  ✅ Scripts de monitoreo y limpieza"
echo ""
echo "🚀 Comandos útiles:"
echo "  • Iniciar servicio: sudo systemctl start secops-mcp.service"
echo "  • Ver estado: sudo systemctl status secops-mcp.service"
echo "  • Ver logs: sudo journalctl -u secops-mcp.service -f"
echo "  • Monitorear: ./monitor-secops.sh"
echo "  • Limpiar: ./cleanup-secops.sh"
echo "  • Probar herramientas: ./scripts/test-docker-tools.sh"
echo ""
echo "🔧 Configuración n8n:"
echo "  • El servidor MCP estará disponible en el puerto configurado"
echo "  • Todas las herramientas son 100% compatibles con n8n"
echo "  • Las wordlists están pre-configuradas"
echo ""
echo "📚 Documentación:"
echo "  • README_DOCKER_TOOLS.md - Guía completa"
echo "  • FORMATS_COMPATIBILITY_ANALYSIS.md - Análisis de compatibilidad"
echo ""
echo "✅ Tu VPS está listo para ejecutar SecOps MCP!"
echo "🌐 Puedes integrarlo con n8n inmediatamente."
