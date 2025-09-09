#!/bin/bash

# Script para configurar el entorno de herramientas Docker para SecOps MCP
# Este script crea los directorios necesarios y limpia contenedores antiguos

echo "🔧 Configurando entorno para herramientas Docker de SecOps MCP..."

# Crear directorios de datos si no existen
echo "📁 Creando directorios de datos..."
mkdir -p data/{nuclei/{templates,config},ffuf/wordlists,sqlmap/output,amass/config,hashcat/{wordlists,hashes},dirsearch/wordlists}

# Limpiar contenedores antiguos si existen
echo "🧹 Limpiando contenedores antiguos..."
docker ps -a --filter "name=secops-" --format "{{.ID}}" | xargs -r docker rm -f

# Verificar que Docker esté funcionando
echo "🐳 Verificando Docker..."
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker no está funcionando. Por favor, inicia Docker y vuelve a intentar."
    exit 1
fi

# Descargar imágenes Docker necesarias
echo "⬇️ Descargando imágenes Docker..."
docker pull projectdiscovery/nuclei:latest
docker pull trickest/ffuf:latest
docker pull uzyexe/nmap:latest
docker pull googlesky/sqlmap:latest
docker pull wpscanteam/wpscan:latest
docker pull owaspamass/amass:latest
docker pull javydekoning/hashcat:latest
docker pull projectdiscovery/httpx:latest
docker pull projectdiscovery/subfinder:latest
docker pull projectdiscovery/tlsx:latest
# Nota: Estas imágenes no están disponibles públicamente, usaremos alternativas
echo "⚠️  Nota: Dirsearch y XSStrike no están disponibles públicamente"
echo "   Usando alternativas: FFUF para directorios y Nuclei para XSS"

# Generar wordlists por defecto para compatibilidad con n8n
echo ""
echo "📝 Generando wordlists por defecto..."
./scripts/generate-default-wordlists.sh

echo ""
echo "✅ Configuración completada!"
echo ""
echo "📋 Herramientas disponibles:"
echo "  • Nuclei (vulnerabilidades): docker run --rm projectdiscovery/nuclei:latest"
echo "  • FFUF (fuzzing web): docker run --rm trickest/ffuf:latest"
echo "  • Nmap (escaneo de red): docker run --rm --cap-add=NET_RAW --cap-add=NET_ADMIN uzyexe/nmap:latest"
echo "  • SQLMap (inyección SQL): docker run --rm googlesky/sqlmap:latest"
echo "  • WPScan (WordPress): docker run --rm wpscanteam/wpscan:latest"
echo "  • Amass (subdominios): docker run --rm owaspamass/amass:latest enum -d example.com"
echo "  • Hashcat (cracking): docker run --rm javydekoning/hashcat:latest"
echo "  • HTTPX (probe HTTP): docker run --rm projectdiscovery/httpx:latest"
echo "  • Subfinder (subdominios): docker run --rm projectdiscovery/subfinder:latest"
echo "  • TLSX (análisis TLS): docker run --rm projectdiscovery/tlsx:latest"
echo "  • Dirsearch (directorios): docker run --rm maurosoria/dirsearch:latest"
echo "  • XSStrike (XSS): docker run --rm s0md3v/xsstrike:latest"
echo ""
echo "🚀 Las herramientas ahora se ejecutarán con 'docker run' cuando se invoquen desde el MCP."
