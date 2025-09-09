import subprocess
import json
from typing import Optional, Dict, Any


def run_hashcat(
    hash_file: str,
    wordlist: str,
    mode: Optional[int] = 0,  # Default to MD5
) -> str:
    """Run Hashcat to crack hashes using Docker.
    
    Args:
        hash_file: Path to file containing hashes
        wordlist: Path to wordlist file
        mode: Hash type (e.g., 0 for MD5, 1000 for NTLM)
    
    Returns:
        str: JSON string containing cracking results
    """
    try:
        # Build the docker run command
        cmd = [
            "docker", "run", "--rm",
            "-v", "./data/hashcat/wordlists:/app/wordlists",
            "-v", "./data/hashcat/hashes:/app/hashes",
            "--device=/dev/dri",  # GPU support
            "javydekoning/hashcat:latest",
            "hashcat", "-m", str(mode), "--potfile-disable", "--outfile-format=2", 
            f"/app/hashes/{hash_file}", f"/app/wordlists/{wordlist}"
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
        return json.dumps({
            "success": True,
            "hash_file": hash_file,
            "mode": mode,
            "results": {
                "output": result.stdout,
                "cracked_hashes": []  # Hashcat output format 2 would be parsed here
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