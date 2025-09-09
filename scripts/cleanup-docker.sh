#!/bin/bash

# Script para limpiar el entorno Docker de SecOps MCP
# Este script elimina contenedores antiguos y limpia recursos no utilizados

echo "🧹 Limpiando entorno Docker de SecOps MCP..."
echo "=============================================="

# Función para confirmar acción
confirm_action() {
    local message="$1"
    echo ""
    read -p "$message (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

# Verificar que Docker esté funcionando
echo "🐳 Verificando Docker..."
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker no está funcionando."
    exit 1
fi

echo "✅ Docker está funcionando correctamente."

# Mostrar contenedores actuales
echo ""
echo "📋 Contenedores actuales:"
docker ps -a --filter "name=secops-" --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"

# Mostrar imágenes
echo ""
echo "🖼️  Imágenes disponibles:"
docker images --filter "reference=*:latest" --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

# Limpiar contenedores secops-*
echo ""
if confirm_action "¿Eliminar todos los contenedores secops-*?"; then
    echo "🗑️  Eliminando contenedores secops-*..."
    docker ps -a --filter "name=secops-" --format "{{.ID}}" | xargs -r docker rm -f
    echo "✅ Contenedores eliminados."
else
    echo "⏭️  Saltando eliminación de contenedores."
fi

# Limpiar contenedores detenidos
echo ""
if confirm_action "¿Eliminar todos los contenedores detenidos?"; then
    echo "🗑️  Eliminando contenedores detenidos..."
    docker container prune -f
    echo "✅ Contenedores detenidos eliminados."
else
    echo "⏭️  Saltando eliminación de contenedores detenidos."
fi

# Limpiar redes no utilizadas
echo ""
if confirm_action "¿Eliminar redes no utilizadas?"; then
    echo "🗑️  Eliminando redes no utilizadas..."
    docker network prune -f
    echo "✅ Redes no utilizadas eliminadas."
else
    echo "⏭️  Saltando eliminación de redes."
fi

# Limpiar volúmenes no utilizados
echo ""
if confirm_action "¿Eliminar volúmenes no utilizados? (¡CUIDADO: Esto eliminará datos!)"; then
    echo "🗑️  Eliminando volúmenes no utilizados..."
    docker volume prune -f
    echo "✅ Volúmenes no utilizados eliminados."
else
    echo "⏭️  Saltando eliminación de volúmenes."
fi

# Limpiar imágenes no utilizadas
echo ""
if confirm_action "¿Eliminar imágenes no utilizadas?"; then
    echo "🗑️  Eliminando imágenes no utilizadas..."
    docker image prune -f
    echo "✅ Imágenes no utilizadas eliminadas."
else
    echo "⏭️  Saltando eliminación de imágenes."
fi

# Limpiar sistema completo
echo ""
if confirm_action "¿Ejecutar limpieza completa del sistema Docker?"; then
    echo "🧹 Ejecutando limpieza completa..."
    docker system prune -f
    echo "✅ Limpieza completa completada."
else
    echo "⏭️  Saltando limpieza completa."
fi

# Mostrar estado final
echo ""
echo "=============================================="
echo "📊 ESTADO FINAL DEL SISTEMA"
echo "=============================================="

echo ""
echo "📋 Contenedores restantes:"
docker ps -a --filter "name=secops-" --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"

echo ""
echo "🖼️  Imágenes restantes:"
docker images --filter "reference=*:latest" --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

echo ""
echo "💾 Uso de disco:"
docker system df

echo ""
echo "✅ Limpieza completada!"
echo ""
echo "💡 Para restaurar el entorno:"
echo "   ./scripts/setup-docker-tools.sh"
echo ""
echo "🧪 Para probar las herramientas:"
echo "   ./scripts/test-docker-tools.sh"
