#!/usr/bin/env python3
"""
HTTP MCP server runner.
This starts the MCP server in HTTP mode on port 8050.
"""
import subprocess
import sys

# Set environment variables for the Docker container
env_vars = {
    "TRANSPORT": "sse",
    "LLM_PROVIDER": "openai",
    "LLM_BASE_URL": "https://api.openai.com/v1", 
    "LLM_API_KEY": "YOUR_OPENAI_API_KEY_HERE",
    "LLM_CHOICE": "gpt-4o-mini",
    "EMBEDDING_MODEL_CHOICE": "text-embedding-3-small",
    "DATABASE_URL": "postgresql://mem0user:mem0password@postgres:5432/mem0db"
}

# Build Docker command for HTTP mode
cmd = [
    "docker", "run", "--rm", 
    "--network", "mcp-mem0_default",
    "-p", "8050:8050"
]

# Add environment variables
for key, value in env_vars.items():
    cmd.extend(["-e", f"{key}={value}"])

# Add the container and command
cmd.extend(["mcp-mem0-mcp-mem0", "uv", "run", "src/main.py"])

# Execute the command
try:
    print("Starting MCP server in HTTP mode on port 8050...")
    subprocess.run(cmd)
except KeyboardInterrupt:
    print("Shutting down MCP server...")
