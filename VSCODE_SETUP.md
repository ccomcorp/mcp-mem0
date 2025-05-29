# VS Code + Augment Configuration for MCP Mem0 Server

This guide shows you how to configure the MCP Mem0 server to work with Augment in Visual Studio Code.

## Prerequisites

1. **Visual Studio Code** with **Augment extension** installed
2. **MCP Mem0 server** running (use `start.bat` or `make start`)
3. **OpenAI API key** configured in `.env` file

## Quick Setup

### Step 1: Start the MCP Server

Run one of these commands in the mcp-mem0 directory:

**Windows:**
```bash
start.bat
```

**Linux/Mac:**
```bash
./start.sh
```

**Or using Make:**
```bash
make start
```

### Step 2: Configure Augment

There are two ways to configure the MCP server in Augment:

#### Option A: Using Augment Settings Panel (Recommended)

1. Open VS Code with the Augment extension
2. Click the **gear icon** in the upper right of the Augment panel
3. In the settings panel, find the **MCP** section
4. Click the **+** button to add a new server
5. Fill in the configuration:
   - **Name:** `mem0`
   - **Command:** `curl`
   - **Args:** `["-N", "http://localhost:8050/sse"]`

#### Option B: Edit settings.json Directly

1. In VS Code, press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
2. Type "Augment: Edit Settings" and select it
3. Under **Advanced**, click **Edit in settings.json**
4. Add this configuration to the `mcpServers` array:

```json
{
  "augment.advanced": {
    "mcpServers": [
      {
        "name": "mem0",
        "command": "curl",
        "args": ["-N", "http://localhost:8050/sse"]
      }
    ]
  }
}
```

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
- Ensure the MCP server is running: `make test`
- Check the server URL: `http://localhost:8050/sse`
- Verify Docker containers are running: `docker ps`

### Memory Not Saving
- Check your OpenAI API key in `.env` file
- View server logs: `make logs`
- Test the server: `python test_mcp_server.py`

### VS Code Configuration Issues
- Restart VS Code after configuration changes
- Check the Augment panel for error messages
- Verify the JSON syntax in settings.json

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
make start

# Stop server  
make stop

# View logs
make logs

# Test functionality
make test

# Clean restart
make clean && make start
```

## Benefits for Coding

With the MCP Mem0 server, Augment can:

1. **Remember project context** across sessions
2. **Recall past solutions** to similar problems
3. **Maintain coding patterns** and conventions
4. **Store learning insights** from debugging
5. **Keep track of team decisions** and architecture choices

This creates a persistent knowledge base that grows with your coding experience!
