# VS Code + Augment Configuration for MCP Mem0 Server

This guide shows you how to configure the MCP Mem0 server to work with Augment in Visual Studio Code.

## Prerequisites

1. **Visual Studio Code** with **Augment extension** installed
2. **MCP Mem0 server** running (use `docker-compose up` or `make start`)
3. **OpenAI API key** configured in `.env` file

## Quick Setup

### Step 1: Start the MCP Server

Run this command in the mcp-mem0 directory:

```bash
docker-compose up
```

**Or using Make:**
```bash
make start
```

### Step 2: Configure Augment

Configure the MCP server in Augment using VS Code settings:

#### Edit settings.json Directly

1. In VS Code, press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
2. Type "Preferences: Open User Settings (JSON)" and select it
3. Add this configuration:

```json
{
  "augment.advanced": {
    "mcpServers": [
      {
        "name": "mem0",
        "command": "python",
        "args": ["H:\\mcp-mem0\\mcp_direct.py"]
      }
    ]
  }
}
```

**Note:** Replace `H:\\mcp-mem0` with the actual path to your mcp-mem0 directory.

### Step 3: Restart VS Code

After configuring the MCP server, restart VS Code to load the new configuration.

## Using the Memory Tools

Once configured, Augment will have access to these memory tools:

### 1. Save Memory
Store information that should persist across coding sessions:
```
"Remember that this project uses TypeScript with strict mode enabled"
```

### 2. Search Memories
Find relevant past information:
```
"What did I learn about the database schema last week?"
```

### 3. Get All Memories
Retrieve all stored memories for context:
```
"Show me all the things I've learned about this codebase"
```

## Example Use Cases

### Project-Specific Memory
```
save_memory("This React project uses Zustand for state management and React Query for API calls")
```

### Code Patterns
```
save_memory("In this codebase, we use the repository pattern with dependency injection")
```

### Bug Solutions
```
save_memory("Fixed the CORS issue by adding credentials: true to the fetch options")
```

### Team Conventions
```
save_memory("Team prefers functional components with hooks over class components")
```

## Troubleshooting

### MCP Server Not Found
- Ensure Docker is running and PostgreSQL container is up: `docker ps`
- Test the MCP server manually: `python mcp_direct.py`
- Verify the script path in the Augment configuration matches your actual directory

### Memory Not Saving
- Check your OpenAI API key in `.env` file
- View server logs: `docker-compose logs -f`
- Ensure PostgreSQL container is running: `docker ps | findstr postgres`

### VS Code Configuration Issues
- Restart VS Code after configuration changes
- Check the Augment panel for error messages
- Verify the JSON syntax in settings.json
- Ensure the path uses double backslashes: `H:\\mcp-mem0\\mcp_direct.py`

## Advanced Configuration

### Custom Port
If you need to use a different port, update both:
1. `docker-compose.yml` - change the port mapping
2. Augment configuration - update the URL

### Multiple Projects
The MCP server can be used across multiple VS Code projects. Just ensure:
1. The server is running (global service)
2. Each VS Code instance has the same Augment configuration

### Memory Organization
Consider using prefixes in your memories for better organization:
```
save_memory("PROJECT_NAME: Uses microservices architecture with Docker")
save_memory("BUG_FIX: Authentication token expires after 1 hour")
save_memory("PATTERN: Use async/await instead of .then() chains")
```

## Server Management Commands

```bash
# Start server
docker-compose up

# Start server in background
docker-compose up -d

# Stop server
docker-compose down

# View logs
docker-compose logs -f

# Clean restart
docker-compose down && docker-compose up
```

## Benefits for Coding

With the MCP Mem0 server, Augment can:

1. **Remember project context** across sessions
2. **Recall past solutions** to similar problems
3. **Maintain coding patterns** and conventions
4. **Store learning insights** from debugging
5. **Keep track of team decisions** and architecture choices

This creates a persistent knowledge base that grows with your coding experience!
