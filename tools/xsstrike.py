import subprocess
import json
from typing import List, Optional, Dict, Any


def run_xsstrike(
    url: str,
    options: Optional[List[str]] = None,
) -> str:
    """Run XSS detection using Nuclei (alternative to XSStrike) via Docker.
    
    Args:
        url: Target URL to scan
        options: Additional options (e.g., ["--crawl", "--blind"])
    
    Returns:
        str: JSON string containing scan results
    """
    try:
        # Build the docker run command using Nuclei as alternative to XSStrike
        cmd = [
            "docker", "run", "--rm",
            "projectdiscovery/nuclei:latest",
            "nuclei", "-u", url, "-t", "xss", "-json"
        ]
        
        if options:
            cmd.extend(options)
        
        # Run the command
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            check=True
        )
        
        # Parse the output
        return json.dumps({
            "success": True,
            "url": url,
            "results": {
                "output": result.stdout,
                "options": options or []
            }
        })
        
    except subprocess.CalledProcessError as e:
        return json.dumps({
            "success": False,
            "error": str(e),
            "stderr": e.stderr
        })
    except Exception as e:
        return json.dumps({
            "success": False,
            "error": str(e)
        })