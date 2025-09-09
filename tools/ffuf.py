import subprocess
import json
from typing import Optional, Dict, Any


def run_ffuf(
    url: str,
    wordlist: str,
    filter_code: Optional[str] = "404",
) -> str:
    """Run ffuf to fuzz web application endpoints using Docker.
    
    Args:
        url: Target URL with FUZZ keyword (e.g., "http://example.com/FUZZ")
        wordlist: Path to wordlist file
        filter_code: HTTP status code to filter out (e.g., "404")
    
    Returns:
        str: JSON string containing fuzzing results
    """
    try:
        # Build the docker run command
        cmd = [
            "docker", "run", "--rm",
            "-v", "./data/ffuf/wordlists:/app/wordlists",
            "trickest/ffuf:latest",
            "ffuf", "-u", url, "-w", f"/app/wordlists/{wordlist}", "-fc", filter_code, "-o", "-", "-of", "json"
        ]
        
        # Run the command
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            check=True,
            cwd="."  # Ensure we're in the project root for volume mounting
        )
        
        # Parse the output
        try:
            data = json.loads(result.stdout)
            return json.dumps({
                "success": True,
                "url": url,
                "results": data
            })
        except json.JSONDecodeError:
            return json.dumps({
                "success": False,
                "error": "Failed to parse JSON output",
                "raw_output": result.stdout
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