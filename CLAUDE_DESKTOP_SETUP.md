# Claude Desktop Setup for MCP Mem0 Server

This guide explains how to configure Claude Desktop to work with the Docker-based MCP Mem0 server using stdio transport.

## Prerequisites

- ✅ Docker Desktop installed and running
- ✅ Claude Desktop installed
- ✅ MCP Mem0 server Docker containers built and available
- ✅ PostgreSQL container running (via docker-compose)

## Configuration Steps

### 1. Locate Claude Desktop Configuration File

The configuration file location depends on your operating system:

- **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`
- **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Linux**: `~/.config/Claude/claude_desktop_config.json`

### 2. Configure MCP Server

Add the following configuration to your `claude_desktop_config.json` file:

```json
{
  "mcpServers": {
    "mem0": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "--network", "mcp-mem0_default",
        "-e", "TRANSPORT=stdio",
        "-e", "LLM_PROVIDER=openai",
        "-e", "LLM_BASE_URL=https://api.openai.com/v1",
        "-e", "LLM_API_KEY=YOUR_OPENAI_API_KEY_HERE",
        "-e", "LLM_CHOICE=gpt-4o-mini",
        "-e", "EMBEDDING_MODEL_CHOICE=text-embedding-3-small",
        "-e", "DATABASE_URL=postgresql://mem0user:mem0password@postgres:5432/mem0db",
        "mcp-mem0-mcp-mem0",
        "uv", "run", "src/main.py"
      ]
    }
  }
}
```

### 3. Update API Key

Replace `YOUR_OPENAI_API_KEY_HERE` with your actual OpenAI API key.

### 4. Ensure Docker Network and Containers

Make sure the required Docker infrastructure is running:

```bash
# Start the MCP Mem0 infrastructure
cd /path/to/mcp-mem0
docker-compose up -d

# Verify containers are running
docker ps --filter "name=mcp-mem0"
```

### 5. Restart Claude Desktop

After updating the configuration:
1. Close Claude Desktop completely
2. Restart Claude Desktop
3. The MCP tools should appear in the tool list

## Available Tools

Once configured, Claude Desktop will have access to these MCP tools:

- **save_memory**: Store information in long-term memory
- **search_memories**: Find relevant memories using semantic search  
- **get_all_memories**: Retrieve all stored memories

## Troubleshooting

### Common Issues

1. **"No module named mem0_mcp" error**
   - Ensure you're using the correct Docker image name: `mcp-mem0-mcp-mem0`
   - Verify the Docker containers are built and available

2. **Network connection errors**
   - Ensure the Docker network `mcp-mem0_default` exists
   - Verify PostgreSQL container is running and healthy

3. **API key errors**
   - Double-check your OpenAI API key is correct
   - Ensure the API key has sufficient credits

4. **Tools not appearing in Claude Desktop**
   - Restart Claude Desktop after configuration changes
   - Check the JSON syntax is valid
   - Verify Docker is running and accessible

### Verification Commands

```bash
# Test the Docker command manually
docker run -i --rm --network mcp-mem0_default \
  -e TRANSPORT=stdio \
  -e LLM_PROVIDER=openai \
  -e LLM_API_KEY=your-key-here \
  mcp-mem0-mcp-mem0 uv run src/main.py

# Check Docker network
docker network ls | grep mcp-mem0

# Check running containers
docker ps --filter "name=mcp-mem0"
```

## Architecture

This setup provides:

- **STDIO Transport**: Direct communication between Claude Desktop and Docker container
- **Docker Isolation**: MCP server runs in isolated container environment
- **Database Persistence**: Memories stored in PostgreSQL with pgvector
- **Dual Transport Support**: SSE mode still available for other clients

## Security Notes

- API keys are passed as environment variables to the Docker container
- Container runs with `--rm` flag for automatic cleanup
- Network isolation through Docker networks
- No persistent container state (stateless operation)

## Next Steps

After successful setup:
1. Test the memory tools in Claude Desktop
2. Verify memories persist across sessions
3. Explore advanced memory management features
4. Consider setting up additional MCP servers using the same pattern
