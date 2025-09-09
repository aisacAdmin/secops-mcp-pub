#!/bin/bash

# Script para probar que todas las herramientas Docker funcionen correctamente
# Este script ejecuta una prueba básica de cada herramienta

echo "🧪 Probando herramientas Docker de SecOps MCP..."
echo "=================================================="

# Función para probar una herramienta
test_tool() {
    local tool_name="$1"
    local docker_cmd="$2"
    local test_description="$3"
    
    echo ""
    echo "🔍 Probando: $tool_name"
    echo "   Descripción: $test_description"
    echo "   Comando: $docker_cmd"
    
    # Ejecutar la herramienta (sin timeout en macOS)
    if bash -c "$docker_cmd" > /dev/null 2>&1; then
        echo "   ✅ ÉXITO: $tool_name funciona correctamente"
        return 0
    else
        echo "   ❌ FALLO: $tool_name no pudo ejecutarse"
        return 1
    fi
}

# Contador de éxitos y fallos
success_count=0
failure_count=0

echo ""
echo "🚀 Iniciando pruebas de herramientas..."

# Probar Nuclei
if test_tool "Nuclei" "docker run --rm projectdiscovery/nuclei:latest  -version" "Verificar versión de Nuclei"; then
    ((success_count++))
else
    ((failure_count++))
fi

# Probar FFUF
if test_tool "FFUF" "docker run --rm trickest/ffuf:latest -u https://example.com/FUZZ -w /dev/null -mc 404 -s -t 1" "Verificar versión de FFUF"; then
    ((success_count++))
else
    ((failure_count++))
fi

# Probar Nmap
if test_tool "Nmap" "docker run --rm --cap-add=NET_RAW --cap-add=NET_ADMIN uzyexe/nmap:latest -version" "Verificar versión de Nmap"; then
    ((success_count++))
else
    ((failure_count++))
fi

# Probar SQLMap
if test_tool "SQLMap" "docker run --rm googlesky/sqlmap:latest python sqlmap-dev/sqlmap.py --version" "Verificar versión de SQLMap"; then
    ((success_count++))
else
    ((failure_count++))
fi

# Probar WPScan
if test_tool "WPScan" "docker run --rm wpscanteam/wpscan:latest --version" "Verificar versión de WPScan"; then
    ((success_count++))
else
    ((failure_count++))
fi

# Probar Amass
if test_tool "Amass" "docker run --rm owaspamass/amass:latest -version" "Verificar versión de Amass"; then
    ((success_count++))
else
    ((failure_count++))
fi

# Probar Hashcat
if test_tool "Hashcat" "docker run --rm javydekoning/hashcat:latest hashcat --version" "Verificar versión de Hashcat"; then
    ((success_count++))
else
    ((failure_count++))
fi

# Probar HTTPX
if test_tool "HTTPX" "docker run --rm projectdiscovery/httpx:latest -version" "Verificar versión de HTTPX"; then
    ((success_count++))
else
    ((failure_count++))
fi

# Probar Subfinder
if test_tool "Subfinder" "docker run --rm projectdiscovery/subfinder:latest --version" "Verificar versión de Subfinder"; then
    ((success_count++))
else
    ((failure_count++))
fi

# Probar TLSX
if test_tool "TLSX" "docker run --rm projectdiscovery/tlsx:latest -version" "Verificar versión de TLSX"; then
    ((success_count++))
else
    ((failure_count++))
fi

# Nota: Dirsearch y XSStrike no están disponibles públicamente
echo ""
echo "⚠️  Nota: Dirsearch y XSStrike no están disponibles públicamente"
echo "   Usando alternativas: FFUF para directorios y Nuclei para XSS"
echo "   Estas herramientas pueden detectar los mismos tipos de vulnerabilidades"

echo ""
echo "=================================================="
echo "📊 RESULTADOS DE LAS PRUEBAS"
echo "=================================================="
echo "✅ Herramientas exitosas: $success_count"
echo "❌ Herramientas fallidas: $failure_count"
echo "📋 Total de herramientas: $((success_count + failure_count))"

if [ $failure_count -eq 0 ]; then
    echo ""
    echo "🎉 ¡Todas las herramientas están funcionando correctamente!"
    echo "🚀 El sistema SecOps MCP está listo para usar."
else
    echo ""
    echo "⚠️  Algunas herramientas fallaron. Revisa los errores arriba."
    echo "💡 Sugerencias:"
    echo "   • Verifica que Docker esté funcionando: docker info"
    echo "   • Ejecuta el script de configuración: ./scripts/setup-docker-tools.sh"
    echo "   • Verifica que las imágenes estén descargadas: docker images"
fi

echo ""
echo "🔧 Para más información, consulta: README_DOCKER_TOOLS.md"