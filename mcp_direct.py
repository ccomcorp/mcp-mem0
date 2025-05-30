#!/usr/bin/env python3
"""
Direct MCP server runner for stdio mode.
This connects to the existing PostgreSQL container and runs the MCP server in stdio mode.
"""
import os
import subprocess
import sys
import os

# Read API key from .env file
api_key = None
env_file = os.path.join(os.path.dirname(__file__), '.env')
if os.path.exists(env_file):
    with open(env_file, 'r') as f:
        for line in f:
            if line.startswith('LLM_API_KEY='):
                api_key = line.split('=', 1)[1].strip()
                break

if not api_key:
    raise ValueError("LLM_API_KEY not found in .env file")

# Set environment variables for the Docker container
env_vars = {
    "TRANSPORT": "stdio",
    "LLM_PROVIDER": "openai",
    "LLM_BASE_URL": "https://api.openai.com/v1",
    "LLM_API_KEY": api_key,
    "LLM_CHOICE": "gpt-4o-mini",
    "EMBEDDING_MODEL_CHOICE": "text-embedding-3-small",
    "DATABASE_URL": "postgresql://mem0user:mem0password@postgres:5432/mem0db"
}

# Build Docker command for stdio mode
cmd = ["docker", "run", "--rm", "-i", "--network", "mcp-mem0_default"]

# Add environment variables
for key, value in env_vars.items():
    cmd.extend(["-e", f"{key}={value}"])

# Add the container and command
cmd.extend(["mcp-mem0-mcp-mem0", "uv", "run", "src/main.py"])

# Execute with proper stdio handling
process = None
try:
    process = subprocess.Popen(
        cmd,
        stdin=sys.stdin,
        stdout=sys.stdout,
        stderr=sys.stderr,
        text=True,
        bufsize=0  # Unbuffered for real-time communication
    )
    process.wait()
except KeyboardInterrupt:
    if process:
        process.terminate()
        process.wait()
