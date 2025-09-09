# SecOps MCP - Herramientas Docker

Este proyecto ha sido actualizado para usar **Docker run** en lugar de contenedores persistentes, resolviendo los problemas de inicialización y fallos de contenedores.

## 🚀 Cambios Principales

### Antes (Docker Compose)
- Contenedores persistentes que se mantenían ejecutándose
- Problemas de inicialización y reinicios constantes
- Uso excesivo de recursos del sistema

### Ahora (Docker Run)
- Contenedores temporales que se ejecutan solo cuando se necesitan
- Sin problemas de inicialización o reinicios
- Uso eficiente de recursos
- Mejor manejo de errores

## 🛠️ Herramientas Disponibles

| Herramienta | Imagen Docker | Descripción |
|-------------|---------------|-------------|
| **Nuclei** | `projectdiscovery/nuclei:latest` | Escáner de vulnerabilidades |
| **FFUF** | `trickest/ffuf:latest` | Fuzzer web |
| **Nmap** | `uzyexe/nmap:latest` | Escáner de red |
| **SQLMap** | `googlesky/sqlmap:latest` | Inyección SQL |
| **WPScan** | `wpscanteam/wpscan:latest` | Escáner de WordPress |
| **Amass** | `owaspamass/amass:latest` | Descubrimiento de subdominios |
| **Hashcat** | `javydekoning/hashcat:latest` | Cracking de contraseñas |
| **HTTPX** | `projectdiscovery/httpx:latest` | Toolkit HTTP |
| **Subfinder** | `projectdiscovery/subfinder:latest` | Descubrimiento de subdominios |
| **TLSX** | `projectdiscovery/tlsx:latest` | Análisis TLS/SSL |
| **Dirsearch** | `maurosoria/dirsearch:latest` | Búsqueda de directorios |
| **XSStrike** | `s0md3v/xsstrike:latest` | Detección de XSS |

## 📋 Instalación y Configuración

### 1. Configurar el entorno
```bash
# Ejecutar el script de configuración
./scripts/setup-docker-tools.sh
```

Este script:
- Crea los directorios de datos necesarios
- Limpia contenedores antiguos
- Descarga todas las imágenes Docker
- Verifica que Docker esté funcionando

### 2. Estructura de directorios
```
data/
├── nuclei/
│   ├── templates/
│   └── config/
├── ffuf/
│   └── wordlists/
├── sqlmap/
│   └── output/
├── amass/
│   └── config/
└── hashcat/
    ├── wordlists/
    └── hashes/
```

## 🔧 Uso de las Herramientas

### Desde el MCP
Las herramientas se ejecutan automáticamente usando `docker run` cuando se invocan desde el MCP. No es necesario mantener contenedores ejecutándose.

### Ejemplo de ejecución
```python
# Cuando se llama a una herramienta, internamente se ejecuta:
docker run --rm projectdiscovery/nuclei:latest nuclei -u target.com -json
```

### Parámetros comunes
- `--rm`: Elimina el contenedor después de la ejecución
- `-v`: Monta volúmenes para datos persistentes
- `--cap-add`: Agrega capacidades especiales (ej: Nmap)

## 🐳 Comandos Docker Directos

Si quieres probar las herramientas manualmente:

```bash
# Nuclei - Escanear vulnerabilidades
docker run --rm projectdiscovery/nuclei:latest nuclei -u https://example.com -json

# Nmap - Escanear puertos
docker run --rm --cap-add=NET_RAW --cap-add=NET_ADMIN uzyexe/nmap:latest nmap -p 80,443 example.com

# FFUF - Fuzzing web
docker run --rm -v $(pwd)/data/ffuf/wordlists:/app/wordlists trickest/ffuf:latest ffuf -u https://example.com/FUZZ -w /app/wordlists/common.txt

# WPScan - Escanear WordPress
docker run --rm wpscanteam/wpscan:latest wpscan --url https://example.com --format json
```

## 🔍 Ventajas del Nuevo Sistema

1. **Confiabilidad**: Sin problemas de inicialización de contenedores
2. **Eficiencia**: Solo se ejecutan cuando se necesitan
3. **Limpieza**: Contenedores se eliminan automáticamente
4. **Mantenimiento**: No hay contenedores huérfanos o fallidos
5. **Recursos**: Uso óptimo de CPU y memoria
6. **Debugging**: Mejor visibilidad de errores

## 🚨 Solución de Problemas

### Error: "Docker no está funcionando"
```bash
# Verificar estado de Docker
docker info

# Iniciar Docker Desktop (macOS/Windows)
# O iniciar servicio (Linux)
sudo systemctl start docker
```

### Error: "Permission denied"
```bash
# Agregar usuario al grupo docker
sudo usermod -aG docker $USER

# O ejecutar con sudo
sudo docker run --rm ...
```

### Error: "Image not found"
```bash
# Descargar imagen manualmente
docker pull projectdiscovery/nuclei:latest

# O ejecutar el script de configuración
./scripts/setup-docker-tools.sh
```

## 📚 Archivos Modificados

- `tools/*.py`: Todas las herramientas ahora usan `docker run`
- `scripts/setup-docker-tools.sh`: Script de configuración
- `docker-compose.yml`: Ya no se usa para las herramientas

## 🎯 Próximos Pasos

1. Ejecutar `./scripts/setup-docker-tools.sh`
2. Probar las herramientas desde el MCP
3. Verificar que los volúmenes se monten correctamente
4. Personalizar configuraciones según necesidades

## 🤝 Contribuciones

Para agregar nuevas herramientas:
1. Crear archivo en `tools/`
2. Usar `docker run --rm` en lugar de comandos locales
3. Agregar imagen al script de configuración
4. Documentar en este README

---

**Nota**: Este sistema elimina la necesidad de mantener contenedores persistentes y proporciona una experiencia más robusta y eficiente.
