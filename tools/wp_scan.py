import subprocess
import json
from typing import Optional

def run_wp_scan(
    target: str,
    api_token: Optional[str] = None,
    output_format: str = "json"
) -> str:
    """
    Wrapper for running WPScan vulnerability scanner using Docker.
    
    Args:
        target: Target URL to scan
        api_token: WPScan API token for enhanced scanning
        output_format: Output format (json, cli, cli-no-color)
    
    Returns:
        JSON string with scan results
    """
    try:
        # Build the docker run command
        cmd = [
            "docker", "run", "--rm",
            "wpscanteam/wpscan:latest",
            "wpscan", "--url", target, "--format", output_format, 
            "--enumerate", "p", "--enumerate", "t", "--enumerate", "u", "--verbose"
        ]
        
        if api_token:
            cmd.extend(["--api-token", api_token])
        
        # Execute the command
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=300  # 5 minutes timeout
        )
        
        if result.returncode == 0:
            return result.stdout
        else:
            return json.dumps({
                "error": "WPScan execution failed",
                "stderr": result.stderr,
                "return_code": result.returncode
            })
            
    except subprocess.TimeoutExpired:
        return json.dumps({
            "error": "WPScan scan timed out after 5 minutes"
        })
    except Exception as e:
        return json.dumps({
            "error": f"Unexpected error: {str(e)}"
        }) 