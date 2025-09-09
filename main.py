import json
from typing import List, Optional, Dict, Any
from fastmcp import FastMCP

# Importar las herramientas Docker
from tools.nuclei import run_nuclei
from tools.ffuf import run_ffuf
from tools.nmap import run_nmap
from tools.sqlmap import run_sqlmap
from tools.wp_scan import run_wp_scan
from tools.amass import run_amass
from tools.hashcat import run_hashcat
from tools.httpx import run_httpx
from tools.subfinder import run_subfinder
from tools.tlsx import run_tlsx
from tools.dirsearch import run_dirsearch
from tools.xsstrike import run_xsstrike

# Create server
mcp = FastMCP(name="secops-mcp",
    version="1.0.0"
)

def check_docker_available() -> bool:
    """Verificar si Docker está disponible en el sistema."""
    import subprocess
    try:
        result = subprocess.run(["docker", "--version"], capture_output=True, text=True, timeout=10)
        return result.returncode == 0
    except:
        return False

@mcp.tool()
def nuclei_scan_wrapper(
    target: str,
    templates: Optional[List[str]] = None,
    severity: Optional[str] = None,
    output_format: str = "json",
) -> str:
    """Wrapper para ejecutar escaneo de seguridad con Nuclei."""
    try:
        if not check_docker_available():
            return json.dumps({
                "success": False,
                "error": "Docker no está disponible en el sistema"
            })
        
        result = run_nuclei(target)
        return result
    except Exception as e:
        return json.dumps({
            "success": False,
            "error": f"Error ejecutando Nuclei: {str(e)}"
        })

@mcp.tool()
def ffuf_wrapper(
    url: str,
    wordlist: str = "directories.txt",
    filter_code: Optional[str] = "404",
) -> str:
    """Wrapper para ejecutar fuzzing con FFUF."""
    try:
        if not check_docker_available():
            return json.dumps({
                "success": False,
                "error": "Docker no está disponible en el sistema"
            })
        
        result = run_ffuf(url, wordlist, filter_code)
        return result
    except Exception as e:
        return json.dumps({
            "success": False,
            "error": f"Error ejecutando FFUF: {str(e)}"
        })

@mcp.tool()
def wfuzz_wrapper(
    url: str,
    wordlist: str = "directories.txt",
    filter_code: Optional[str] = "404",
) -> str:
    """Wrapper para ejecutar fuzzing con WFuzz (usando FFUF como alternativa)."""
    try:
        if not check_docker_available():
            return json.dumps({
                "success": False,
                "error": "Docker no está disponible en el sistema"
            })
        
        # WFuzz no está disponible, usamos FFUF como alternativa
        result = run_ffuf(url, wordlist, filter_code)
        return result
    except Exception as e:
        return json.dumps({
            "success": False,
            "error": f"Error ejecutando WFuzz (FFUF): {str(e)}"
        })

@mcp.tool()
def sqlmap_wrapper(
    url: str,
    risk: Optional[int] = 1,
    level: Optional[int] = 1,
) -> str:
    """Wrapper para ejecutar escaneo SQLMap."""
    try:
        if not check_docker_available():
            return json.dumps({
                "success": False,
                "error": "Docker no está disponible en el sistema"
            })
        
        result = run_sqlmap(url)
        return result
    except Exception as e:
        return json.dumps({
            "success": False,
            "error": f"Error ejecutando SQLMap: {str(e)}"
        })

@mcp.tool()
def nmap_wrapper(
    target: str,
    ports: Optional[str] = None,
    scan_type: Optional[str] = "sV",
) -> str:
    """Wrapper para ejecutar escaneo Nmap."""
    try:
        if not check_docker_available():
            return json.dumps({
                "success": False,
                "error": "Docker no está disponible en el sistema"
            })
        
        result = run_nmap(target)
        return result
    except Exception as e:
        return json.dumps({
            "success": False,
            "error": f"Error ejecutando Nmap: {str(e)}"
        })

@mcp.tool()
def hashcat_wrapper(
    hash_file: str,
    wordlist: str,
    hash_type: str,
) -> str:
    """Wrapper para ejecutar cracking con Hashcat."""
    try:
        if not check_docker_available():
            return json.dumps({
                "success": False,
                "error": "Docker no está disponible en el sistema"
            })
        
        result = run_hashcat(hash_file, wordlist, hash_type)
        return result
    except Exception as e:
        return json.dumps({
            "success": False,
            "error": f"Error ejecutando Hashcat: {str(e)}"
        })

@mcp.tool()
def httpx_wrapper(
    urls: List[str],
    status_codes: Optional[List[int]] = None,
) -> str:
    """Wrapper para ejecutar escaneo HTTPX."""
    try:
        if not check_docker_available():
            return json.dumps({
                "success": False,
                "error": "Docker no está disponible en el sistema"
            })
        
        result = run_httpx(urls)
        return result
    except Exception as e:
        return json.dumps({
            "success": False,
                "error": f"Error ejecutando HTTPX: {str(e)}"
        })

@mcp.tool()
def subfinder_wrapper(
    domain: str,
    recursive: bool = False,
) -> str:
    """Wrapper para ejecutar descubrimiento de subdominios con Subfinder."""
    try:
        if not check_docker_available():
            return json.dumps({
                "success": False,
                "error": "Docker no está disponible en el sistema"
            })
        
        result = run_subfinder(domain)
        return result
    except Exception as e:
        return json.dumps({
            "success": False,
            "error": f"Error ejecutando Subfinder: {str(e)}"
        })

@mcp.tool()
def tlsx_wrapper(
    host: str,
    port: Optional[int] = 443,
) -> str:
    """Wrapper para ejecutar análisis TLSX."""
    try:
        if not check_docker_available():
            return json.dumps({
                "success": False,
                "error": "Docker no está disponible en el sistema"
            })
        
        result = run_tlsx(host, port)
        return result
    except Exception as e:
        return json.dumps({
            "success": False,
            "error": f"Error ejecutando TLSX: {str(e)}"
        })

@mcp.tool()
def xsstrike_wrapper(
    url: str,
    crawl: bool = False,
) -> str:
    """Wrapper para ejecutar escaneo XSStrike."""
    try:
        if not check_docker_available():
            return json.dumps({
                "success": False,
                "error": "Docker no está disponible en el sistema"
            })
        
        result = run_xsstrike(url)
        return result
    except Exception as e:
        return json.dumps({
            "success": False,
            "error": f"Error ejecutando XSStrike: {str(e)}"
        })

@mcp.tool()
def amass_wrapper(
    domain: str,
    passive: bool = True,
) -> str:
    """Wrapper para ejecutar descubrimiento con Amass."""
    try:
        if not check_docker_available():
            return json.dumps({
                "success": False,
                "error": "Docker no está disponible en el sistema"
            })
        
        result = run_amass(domain)
        return result
    except Exception as e:
        return json.dumps({
            "success": False,
            "error": f"Error ejecutando Amass: {str(e)}"
        })

@mcp.tool()
def dirsearch_wrapper(
    url: str,
    extensions: Optional[List[str]] = None,
    wordlist: Optional[str] = None,
) -> str:
    """Wrapper para ejecutar búsqueda de directorios con Dirsearch."""
    try:
        if not check_docker_available():
            return json.dumps({
                "success": False,
                "error": "Docker no está disponible en el sistema"
            })
        
        result = run_dirsearch(url, wordlist)
        return result
    except Exception as e:
        return json.dumps({
            "success": False,
            "error": f"Error ejecutando Dirsearch: {str(e)}"
        })

@mcp.tool()
def wp_scan_wrapper(
    target: str,
    api_token: Optional[str] = None,
    output_format: str = "json"
) -> str:
    """Wrapper para ejecutar escaneo WPScan."""
    try:
        if not check_docker_available():
            return json.dumps({
                "success": False,
                "error": "Docker no está disponible en el sistema"
            })
        
        result = run_wp_scan(target, output_format)
        return result
    except Exception as e:
        return json.dumps({
            "success": False,
            "error": f"Error ejecutando WPScan: {str(e)}"
        })

@mcp.tool()
def get_tools_status() -> str:
    """Obtener el estado de todas las herramientas Docker."""
    tools_list = [
        "nuclei", "ffuf", "nmap", "sqlmap", "wpscan", 
        "amass", "hashcat", "httpx", "subfinder", "tlsx",
        "dirsearch", "xsstrike"
    ]
    
    status = {}
    for tool_name in tools_list:
        status[tool_name] = {
            "available": True,
            "type": "docker-run",
            "status": "ready"
        }
    
    return json.dumps({
        "success": True,
        "tools": status,
        "total_tools": len(tools_list),
        "architecture": "docker-run",
        "message": "Todas las herramientas están disponibles para ejecución on-demand"
    })

@mcp.tool()
def ping_tool(tool_name: str) -> str:
    """Hacer ping a una herramienta específica."""
    tools_list = [
        "nuclei", "ffuf", "nmap", "sqlmap", "wpscan", 
        "amass", "hashcat", "httpx", "subfinder", "tlsx",
        "dirsearch", "xsstrike"
    ]
    
    if tool_name not in tools_list:
        return json.dumps({
            "success": False,
            "error": f"Herramienta {tool_name} no encontrada"
        })
    
    if not check_docker_available():
        return json.dumps({
            "success": False,
            "tool": tool_name,
            "status": "offline",
            "error": "Docker no está disponible en el sistema"
        })
    
    return json.dumps({
        "success": True,
        "tool": tool_name,
        "status": "online",
        "type": "docker-run",
        "message": "Herramienta disponible para ejecución on-demand"
    })

if __name__ == "__main__":
    print("🔒 SecOps MCP Server iniciando...")
    print("📊 Herramientas disponibles:")
    tools_list = [
        "nuclei", "ffuf", "nmap", "sqlmap", "wpscan", 
        "amass", "hashcat", "httpx", "subfinder", "tlsx",
        "dirsearch", "xsstrike"
    ]
    
    for tool_name in tools_list:
        print(f"  - {tool_name}")
    
    print(f"\n🚀 Servidor MCP iniciando en puerto 8080...")
    print("💡 Arquitectura: Docker run on-demand (sin contenedores persistentes)")
    print("   Las herramientas se ejecutan solo cuando se solicitan")
    
    # Verificar Docker
    if check_docker_available():
        print("✅ Docker está disponible")
    else:
        print("❌ Docker no está disponible")
        print("   Asegúrate de que Docker esté instalado y funcionando")
        exit(1)
    
    # Iniciar servidor MCP
    mcp.run()