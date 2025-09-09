# WPScan Tool

Este módulo proporciona un wrapper para el scanner de vulnerabilidades de WordPress WPScan.

## Instalación

Antes de usar esta herramienta, asegúrate de tener WPScan instalado:

```bash
# Instalar WPScan via RubyGems
gem install wpscan

# O usar el paquete del sistema (Ubuntu/Debian)
sudo apt install wpscan

# O usar Homebrew (macOS)
brew install wpscan
```

## Herramienta Disponible

### `wp_scan_wrapper`
Scanner completo de WPScan que incluye:
- Escaneo de vulnerabilidades de plugins
- Escaneo de vulnerabilidades de temas
- Enumeración de usuarios
- Salida verbosa para máximo detalle

**Parámetros:**
- `target`: URL del sitio WordPress a escanear (requerido)
- `api_token`: Token de API de WPScan para escaneo mejorado (opcional)
- `output_format`: Formato de salida (json, cli, cli-no-color) - default: "json"

**Ejemplo básico:**
```python
result = await client.call_tool("wp_scan_wrapper", {
    "target": "https://example.com"
})
```

**Ejemplo con API token:**
```python
result = await client.call_tool("wp_scan_wrapper", {
    "target": "https://example.com",
    "api_token": "your_api_token_here"
})
```

## Token de API

Para obtener un token de API de WPScan:
1. Regístrate en [wpscan.com](https://wpscan.com)
2. Ve a tu perfil y genera un token
3. Usa el token para escaneos mejorados

## Características del Escaneo

La herramienta ejecuta automáticamente:
- `--enumerate p` - Escaneo de plugins
- `--enumerate t` - Escaneo de temas  
- `--enumerate u` - Enumeración de usuarios
- `--verbose` - Salida detallada

## Ejemplos de Uso

### Escaneo básico
```python
result = await client.call_tool("wp_scan_wrapper", {
    "target": "https://wordpress-site.com"
})
```

### Escaneo con formato CLI
```python
result = await client.call_tool("wp_scan_wrapper", {
    "target": "https://wordpress-site.com",
    "output_format": "cli"
})
```

### Escaneo mejorado con API token
```python
result = await client.call_tool("wp_scan_wrapper", {
    "target": "https://wordpress-site.com",
    "api_token": "your_api_token_here",
    "output_format": "json"
})
```

## Notas Importantes

- **Timeout**: Los escaneos tienen un timeout de 5 minutos
- **Formato de salida**: Por defecto se usa JSON para fácil procesamiento
- **Manejo de errores**: Devuelve JSON con información de error si algo falla
- **Seguridad**: Solo escanea sitios que tengas permiso para probar
- **Escaneo completo**: Siempre ejecuta un escaneo comprehensivo

## Troubleshooting

### Error: "WPScan not found"
```bash
gem install wpscan
```

### Error: "Permission denied"
```bash
sudo gem install wpscan
```

### Error: "Timeout"
- Los escaneos grandes pueden tardar más de 5 minutos
- Considera usar un API token para escaneos más rápidos

## Integración con MCP

Esta herramienta está disponible como herramienta MCP estándar y puede ser llamada desde cualquier cliente MCP compatible. 