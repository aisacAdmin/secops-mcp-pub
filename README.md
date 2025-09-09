Perfecto 💯, aquí tienes el README completo listo para meterlo en tu repo como README.md:

# 🔐 SecOps MCP (Public Edition)

[![FastMCP](https://img.shields.io/badge/FastMCP-Compatible-green)](https://gofastmcp.com)  
Servidor MCP para automatizar flujos de ciberseguridad con **n8n**, **Docker** y **agentes de IA**.

---

## 📌 Descripción

Este proyecto implementa un **MCP Server** especializado en **Seguridad Ofensiva**.  
Permite exponer herramientas clásicas de pentesting como **Nmap, Nuclei, SQLMap, FFUF, Subfinder, WPScan, Amass, XSStrike, HTTPX, TLSX, WFuzz**, etc., a través del protocolo [Model Context Protocol (MCP)](https://gofastmcp.com).

De esta forma, cualquier **agente MCP-compatible** (como `n8n` o integraciones personalizadas) puede invocar escaneos, recibir resultados en JSON y orquestar pipelines de seguridad de manera **asíncrona, segura y escalable**.

---

## ⚡ Características

- ✅ **Integración nativa con MCP** (compatible con `streamable-http`)  
- ✅ **14 herramientas de seguridad integradas**  
- ✅ **Salidas uniformes en JSON** para facilitar automatizaciones  
- ✅ **Soporte de autenticación vía API Key**  
- ✅ **Control de concurrencia y rate limiting**  
- ✅ **Endpoints de health y readiness** (`/health`, `/ready`)  
- ✅ **Diseñado para producción** con `Hypercorn + Unix Socket` y `Caddy` como reverse proxy  

---

## 🛠️ Herramientas soportadas

- [x] `nmap` – escaneo de puertos y servicios  
- [x] `nuclei` – búsqueda de vulnerabilidades con templates  
- [x] `sqlmap` – inyección SQL automatizada  
- [x] `ffuf` / `wfuzz` – fuzzing web y de directorios  
- [x] `subfinder` y `amass` – descubrimiento de subdominios  
- [x] `wpscan` – auditoría de sitios WordPress  
- [x] `xsstrike` – detección de XSS  
- [x] `httpx` – sondeo HTTP masivo  
- [x] `tlsx` – análisis de certificados TLS  

---

## 🚀 Despliegue rápido

### 1. Clonar el repo
```bash
git clone https://github.com/aisacAdmin/secops-mcp-pub.git
cd secops-mcp-pub
```

2. Crear entorno virtual

python3 -m venv secops-env
source secops-env/bin/activate
pip install -r requirements.txt

3. Variables de entorno

Crear un archivo .env:

MCP_API_KEY=secops-mcp-stable-key-2024
MCP_ALLOWED_IPS=127.0.0.1,localhost
MCP_RATE_LIMIT=true

4. Ejecutar el servidor

python main.py

Por defecto escucha en http://0.0.0.0:8080.

⸻

🧩 Integración con n8n

Con el Community Node de MCP en n8n puedes:
	1.	Configurar el endpoint: https://tu-servidor/mcp
	2.	Añadir tu API Key en los headers
	3.	Llamar a cualquier herramienta (nmap_scan_wrapper, nuclei_scan_wrapper, etc.)

Ejemplo de petición desde cURL:

curl -X POST https://mcp.tu-dominio/mcp \
  -H "Authorization: Bearer secops-mcp-stable-key-2024" \
  -H "Content-Type: application/json" \
  -d '{"type":"ListToolsRequest"}'


⸻

📊 Roadmap
	•	Añadir más herramientas de análisis (gobuster, hydra, etc.)
	•	Dashboard web ligero para monitorización
	•	Soporte multi-tenant con Supabase

⸻

🤝 Contribuciones

Este repo es público para la comunidad.
Se aceptan PRs con mejoras de seguridad, optimización de wrappers y soporte de nuevas herramientas.

⸻

📜 Licencia

MIT License © 2025 AISAC / CISEC

---

¿Quieres que te lo prepare directamente como archivo `README.md` dentro del repo `secops-mcp-public` para que solo hagas `git add . && git commit -m "add readme" && git push`?
