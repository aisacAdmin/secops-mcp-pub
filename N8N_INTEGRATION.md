# 🔗 Integración con n8n - SecOps MCP

## 🎯 **Visión General**

SecOps MCP está diseñado específicamente para integrarse con **n8n** y proporcionar herramientas de ciberseguridad y pentesting a tus flujos de automatización. El servidor MCP se ejecuta directamente en el VPS, mientras que las herramientas de seguridad operan en contenedores Docker independientes.

## 🏗️ **Arquitectura para n8n**

```
┌─────────────────────────────────────────────────────────────┐
│                        n8n                                 │
│                 (Tu VPS/Cloud)                             │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                Servidor MCP Principal                       │
│              (Ejecutándose en VPS)                         │
│              ┌─────────────────────────┐                   │
│              │     FastMCP Server      │                   │
│              │   (Python + FastMCP)    │                   │
│              └─────────────────────────┘                   │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│              Contenedores Docker                            │
│              (Herramientas de Seguridad)                   │
│                                                             │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐         │
│  │ Nuclei  │ │  FFUF   │ │  Nmap   │ │ SQLMap  │         │
│  │ :8081   │ │ :8082   │ │ :8083   │ │ :8084   │         │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘         │
│                                                             │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐         │
│  │ WPScan  │ │  Amass  │ │Hashcat  │ │ HTTPX   │         │
│  │ :8085   │ │ :8086   │ │ :8087   │ │ :8088   │         │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘         │
│                                                             │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐                     │
│  │Subfinder│ │  TLSX   │ │Dirsearch│                     │
│  │ :8089   │ │ :8090   │ │ :8091   │                     │
│  └─────────┘ └─────────┘ └─────────┘                     │
└─────────────────────────────────────────────────────────────┘
```

## 🚀 **Instalación en VPS**

### **1. Instalación Automática (Recomendada)**

```bash
# Clonar el repositorio
git clone https://github.com/yourusername/secops-mcp.git
cd secops-mcp

# Ejecutar instalación completa
./scripts/install-vps.sh install
```

### **2. Instalación Manual**

```bash
# Instalar Python y dependencias
./scripts/install-vps.sh python

# Instalar Docker
./scripts/install-vps.sh docker

# Configurar proyecto
./scripts/install-vps.sh systemd
```

### **3. Verificar Instalación**

```bash
# Verificar estado de todos los componentes
./scripts/install-vps.sh verify

# Verificar estado del servicio MCP
sudo systemctl status secops-mcp

# Verificar herramientas disponibles
curl http://localhost:8080/health
```

## 🔧 **Configuración para n8n**

### **1. Configurar Firewall**

```bash
# Abrir puertos necesarios
sudo ufw allow 8080/tcp  # Servidor MCP
sudo ufw allow 8081/tcp  # Nuclei
sudo ufw allow 8082/tcp  # FFUF
sudo ufw allow 8083/tcp  # Nmap
sudo ufw allow 8084/tcp  # SQLMap
sudo ufw allow 8085/tcp  # WPScan
sudo ufw allow 8086/tcp  # Amass
sudo ufw allow 8087/tcp  # Hashcat
sudo ufw allow 8088/tcp  # HTTPX
sudo ufw allow 8089/tcp  # Subfinder
sudo ufw allow 8090/tcp  # TLSX

# Verificar estado
sudo ufw status
```

### **2. Variables de Entorno**

```bash
# Copiar archivo de ejemplo
cp env.example .env

# Editar configuración
nano .env
```

**Configuración recomendada para VPS:**
```bash
# Configuración del servidor MCP
MCP_HOST=0.0.0.0
MCP_PORT=8080

# Tokens de API
WPSCAN_API_TOKEN=your_wpscan_api_token_here

# Configuración de seguridad
SCAN_TIMEOUT=600
MAX_CONCURRENT_SCANS=10
RATE_LIMIT_PER_MINUTE=120

# Configuración de red
DOCKER_NETWORK_SUBNET=172.20.0.0/16
```

### **3. Iniciar Servicios**

```bash
# Iniciar contenedores Docker
docker-compose up -d

# Iniciar servicio MCP
sudo systemctl start secops-mcp

# Verificar estado
sudo systemctl status secops-mcp
docker-compose ps
```

## 🔌 **Integración con n8n**

### **1. Configurar n8n para usar MCP**

En tu instancia de n8n, configura el servidor MCP:

```json
{
  "mcp": {
    "servers": [
      {
        "name": "secops-mcp",
        "url": "http://tu-vps-ip:8080",
        "transport": "http"
      }
    ]
  }
}
```

### **2. Nodos MCP Disponibles**

Una vez configurado, tendrás acceso a estos nodos en n8n:

#### **🔍 Reconnaissance**
- **Amass**: Descubrimiento de subdominios
- **Subfinder**: Enumeración de subdominios
- **HTTPX**: Escaneo HTTP de URLs

#### **🚨 Análisis de Vulnerabilidades**
- **Nuclei**: Escaneo de vulnerabilidades
- **WPScan**: Escaneo de WordPress
- **SQLMap**: Detección de inyección SQL

#### **🌐 Web Security**
- **FFUF**: Fuzzing de directorios
- **Dirsearch**: Búsqueda de rutas web
- **XSStrike**: Detección de XSS

#### **🌍 Network Security**
- **Nmap**: Escaneo de puertos y servicios
- **TLSX**: Análisis de certificados SSL/TLS

#### **🔐 Password Security**
- **Hashcat**: Cracking de contraseñas

### **3. Ejemplos de Flujos n8n**

#### **Flujo 1: Escaneo Automático de Dominios**

```json
{
  "nodes": [
    {
      "name": "Trigger",
      "type": "n8n-nodes-base.scheduleTrigger",
      "parameters": {
        "rule": {
          "hour": 2,
          "minute": 0
        }
      }
    },
    {
      "name": "Discover Subdomains",
      "type": "n8n-nodes-base.mcp",
      "parameters": {
        "tool": "amass_wrapper",
        "arguments": {
          "domain": "example.com",
          "passive": true
        }
      }
    },
    {
      "name": "Scan Vulnerabilities",
      "type": "n8n-nodes-base.mcp",
      "parameters": {
        "tool": "nuclei_scan_wrapper",
        "arguments": {
          "target": "{{ $json.domain }}",
          "severity": "high"
        }
      }
    },
    {
      "name": "Send Alert",
      "type": "n8n-nodes-base.slack",
      "parameters": {
        "channel": "#security-alerts",
        "text": "Vulnerabilidades encontradas en {{ $json.target }}"
      }
    }
  ]
}
```

#### **Flujo 2: Monitoreo de WordPress**

```json
{
  "nodes": [
    {
      "name": "WordPress Sites",
      "type": "n8n-nodes-base.code",
      "parameters": {
        "jsCode": "return [\n  { site: 'https://site1.com' },\n  { site: 'https://site2.com' }\n];"
      }
    },
    {
      "name": "WPScan",
      "type": "n8n-nodes-base.mcp",
      "parameters": {
        "tool": "wp_scan_wrapper",
        "arguments": {
          "target": "{{ $json.site }}",
          "api_token": "{{ $env.WPSCAN_API_TOKEN }}"
        }
      }
    },
    {
      "name": "Process Results",
      "type": "n8n-nodes-base.code",
      "parameters": {
        "jsCode": "const results = JSON.parse($input.first().json);\nif (results.vulnerabilities && results.vulnerabilities.length > 0) {\n  return {\n    site: $input.first().json.site,\n    vulnerabilities: results.vulnerabilities,\n    alert: true\n  };\n}\nreturn { alert: false };"
      }
    }
  ]
}
```

#### **Flujo 3: Escaneo de Red**

```json
{
  "nodes": [
    {
      "name": "Network Range",
      "type": "n8n-nodes-base.code",
      "parameters": {
        "jsCode": "return [\n  { range: '192.168.1.0/24' },\n  { range: '10.0.0.0/24' }\n];"
      }
    },
    {
      "name": "Nmap Scan",
      "type": "n8n-nodes-base.mcp",
      "parameters": {
        "tool": "nmap_wrapper",
        "arguments": {
          "target": "{{ $json.range }}",
          "scan_type": "sV"
        }
      }
    },
    {
      "name": "Save Results",
      "type": "n8n-nodes-base.fileOperations",
      "parameters": {
        "operation": "write",
        "fileName": "scan-{{ $now.format('YYYY-MM-DD-HH-mm') }}.json",
        "data": "{{ JSON.stringify($json) }}"
      }
    }
  ]
}
```

## 📊 **Monitoreo y Logs**

### **1. Ver Logs del Servidor MCP**

```bash
# Logs en tiempo real
sudo journalctl -u secops-mcp -f

# Últimas 100 líneas
sudo journalctl -u secops-mcp -n 100

# Logs desde el inicio del día
sudo journalctl -u secops-mcp --since today
```

### **2. Ver Logs de Contenedores**

```bash
# Todos los contenedores
docker-compose logs -f

# Contenedor específico
docker-compose logs -f nuclei

# Últimas líneas
docker-compose logs --tail=50 ffuf
```

### **3. Métricas de Rendimiento**

```bash
# Estado de contenedores
docker-compose ps

# Uso de recursos
docker stats

# Espacio en disco
docker system df
```

## 🔒 **Seguridad y Hardening**

### **1. Usuario de Servicio**

```bash
# Verificar usuario secops
id secops

# Cambiar contraseña (si es necesario)
sudo passwd secops
```

### **2. Permisos de Archivos**

```bash
# Verificar permisos
ls -la /opt/secops-mcp/

# Ajustar permisos si es necesario
sudo chmod 750 /opt/secops-mcp/
sudo chown -R secops:secops /opt/secops-mcp/
```

### **3. Firewall y Red**

```bash
# Solo permitir acceso desde IPs específicas
sudo ufw allow from tu-ip-n8n to any port 8080

# Verificar reglas
sudo ufw status numbered
```

## 🚨 **Troubleshooting**

### **Problemas Comunes**

#### **Servidor MCP no inicia**
```bash
# Verificar logs
sudo journalctl -u secops-mcp -n 50

# Verificar dependencias
sudo systemctl status docker

# Verificar puerto
netstat -tulpn | grep :8080
```

#### **Contenedores no responden**
```bash
# Verificar estado
docker-compose ps

# Verificar logs
docker-compose logs nuclei

# Reiniciar contenedores
docker-compose restart
```

#### **Problemas de conectividad**
```bash
# Verificar red Docker
docker network ls
docker network inspect secops-mcp_secops-network

# Verificar conectividad entre contenedores
docker exec secops-nuclei ping secops-ffuf
```

### **Comandos de Diagnóstico**

```bash
# Estado general del sistema
./scripts/manage-containers.sh status

# Verificar salud de herramientas
./scripts/manage-containers.sh health

# Logs de herramientas específicas
./scripts/manage-containers.sh logs nuclei
```

## 📈 **Escalabilidad y Rendimiento**

### **1. Ajustar Recursos**

```bash
# Limitar uso de CPU y memoria por contenedor
# En docker-compose.yml:
services:
  nuclei:
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 1G
        reservations:
          cpus: '0.5'
          memory: 512M
```

### **2. Escalar Herramientas**

```bash
# Escalar Nuclei a 3 instancias
docker-compose up -d --scale nuclei=3

# Escalar múltiples servicios
docker-compose up -d --scale nuclei=2 --scale ffuf=2
```

### **3. Load Balancing**

```yaml
# Ejemplo con Nginx
nginx:
  image: nginx:alpine
  ports:
    - "80:80"
  volumes:
    - ./nginx.conf:/etc/nginx/nginx.conf
  depends_on:
    - nuclei
    - ffuf
```

## 🔮 **Futuras Mejoras**

- [ ] **API REST adicional** para integración directa con n8n
- [ ] **Webhook endpoints** para notificaciones en tiempo real
- [ ] **Dashboard web** para visualización de resultados
- [ **Integración con SIEM** y herramientas de gestión de incidentes
- [ ] **Plugin system** para herramientas personalizadas
- [ ] **Kubernetes** para orquestación avanzada

---

**💡 Consejo**: Esta arquitectura te permite mantener el servidor MCP ejecutándose directamente en el VPS para máxima estabilidad, mientras que las herramientas de seguridad se ejecutan en contenedores Docker para fácil mantenimiento y actualización.

**🚀 Para empezar**: Ejecuta `./scripts/install-vps.sh install` y tendrás todo configurado para integrar con n8n en minutos. 