<h1 align="center">MCP-Mem0: Long-Term Memory for AI Agents</h1>

<p align="center">
  <img src="public/Mem0AndMCP.png" alt="Mem0 and MCP Integration" width="600">
</p>

A template implementation of the [Model Context Protocol (MCP)](https://modelcontextprotocol.io) server integrated with [Mem0](https://mem0.ai) for providing AI agents with persistent memory capabilities.

Use this as a reference point to build your MCP servers yourself, or give this as an example to an AI coding assistant and tell it to follow this example for structure and code correctness!

## Overview

This project demonstrates how to build an MCP server that enables AI agents to store, retrieve, and search memories using semantic search. It serves as a practical template for creating your own MCP servers, simply using Mem0 and a practical example.

The implementation follows the best practices laid out by Anthropic for building MCP servers, allowing seamless integration with any MCP-compatible client.

## Features

The server provides three essential memory management tools:

1. **`save_memory`**: Store any information in long-term memory with semantic indexing
2. **`get_all_memories`**: Retrieve all stored memories for comprehensive context
3. **`search_memories`**: Find relevant memories using semantic search

## Prerequisites

- Python 3.12+
- Supabase or any PostgreSQL database (for vector storage of memories)
- API keys for your chosen LLM provider (OpenAI, OpenRouter, or Ollama)
- Docker if running the MCP server as a container (recommended)

## Installation

### Using uv

1. Install uv if you don't have it:
   ```bash
   pip install uv
   ```

2. Clone this repository:
   ```bash
   git clone https://github.com/coleam00/mcp-mem0.git
   cd mcp-mem0
   ```

3. Install dependencies:
   ```bash
   uv pip install -e .
   ```

4. Create a `.env` file based on `.env.example`:
   ```bash
   cp .env.example .env
   ```

5. Configure your environment variables in the `.env` file (see Configuration section)

### Using Docker (Recommended)

1. Build the Docker image:
   ```bash
   docker build -t mcp/mem0 --build-arg PORT=8050 .
   ```

2. Create a `.env` file based on `.env.example` and configure your environment variables

## Configuration

The following environment variables can be configured in your `.env` file:

| Variable | Description | Default Value |
|----------|-------------|---------------|
| `TRANSPORT` | Transport protocol (sse or stdio) | `stdio` |
| `HOST` | Host to bind to when using SSE transport | `0.0.0.0` |
| `PORT` | Port to listen on when using SSE transport | `8050` |
| `LLM_PROVIDER` | LLM provider (openai, openrouter, or ollama) | `openai` |
| `LLM_BASE_URL` | Base URL for the LLM API | `https://api.openai.com/v1` |
| `LLM_API_KEY` | API key for the LLM provider | `sk-your-openai-api-key-here` |
| `LLM_CHOICE` | LLM model to use | `gpt-4o-mini` |
| `EMBEDDING_MODEL_CHOICE` | Embedding model to use | `text-embedding-3-small` |
| `DATABASE_URL` | PostgreSQL connection string | `postgresql://mem0user:mem0password@localhost:5432/mem0db` |

## Running the Server

### Using uv

#### SSE Transport

```bash
# Set TRANSPORT=sse in .env then:
uv run src/main.py
```

The MCP server will essentially be run as an API endpoint that you can then connect to with config shown below.

#### Stdio Transport

With stdio, the MCP client iself can spin up the MCP server, so nothing to run at this point.

### Using Docker

#### Quick Start with Smart Startup (Recommended)

The easiest way to get started is with **one command**:

**Windows:**
```bash
start.bat
```

**Cross-platform:**
```bash
python start_server.py
```

**Or using Make:**
```bash
make start
```

The smart startup script will:
- ✅ Check if Docker is running
- ✅ Detect existing containers and reuse them
- ✅ Only recreate containers when necessary
- ✅ Provide clear status information
- ✅ Test server connectivity

The server will be available at `http://localhost:8050/sse`.

#### Smart Startup Benefits

- **🚀 Fast Restarts:** Reuses existing containers instead of recreating them
- **🔍 Intelligent Detection:** Automatically detects running containers
- **📊 Clear Status:** Shows exactly what's happening during startup
- **🛡️ Safe Operation:** Won't create duplicate containers
- **⚡ Efficient:** Only rebuilds when code or config changes

**Environment Configuration**: Edit the `.env` file and add your OpenAI API key:
```bash
OPENAI_API_KEY=your-openai-api-key-here
DATABASE_URL=postgresql://mem0user:mem0password@localhost:5432/mem0db
```

#### Manual Docker Compose
```bash
# Clone the repository
git clone https://github.com/coleam00/mcp-mem0.git
cd mcp-mem0

# Start the services
docker-compose up
```

#### SSE Transport (Manual Docker)

```bash
docker run --env-file .env -p:8050:8050 mcp/mem0
```

The MCP server will essentially be run as an API endpoint within the container that you can then connect to with config shown below.

#### Stdio Transport

With stdio, the MCP client iself can spin up the MCP server container, so nothing to run at this point.

## Integration with MCP Clients

### MCP Dockmaster

For easy setup with MCP Dockmaster, use these exact configuration values:

**Repository URL**: `https://github.com/ccomcorp/mcp-mem0`

**Command**: `python`
**Arguments**: `main.py`

**Environment Variables**:
```
TRANSPORT=stdio
LLM_PROVIDER=openai
LLM_BASE_URL=https://api.openai.com/v1
LLM_API_KEY=sk-your-openai-api-key-here
LLM_CHOICE=gpt-4o-mini
EMBEDDING_MODEL_CHOICE=text-embedding-3-small
DATABASE_URL=postgresql://mem0user:mem0password@localhost:5432/mem0db
```

**Expected Result**: Server status should show "Running" with "3 tools available".

### VS Code + Augment (Recommended)

For the best experience with VS Code and Augment:

1. **Start the server**: Run `docker-compose up`
2. **Configure Augment**: Add this to your VS Code settings.json:
   ```json
   {
     "augment.advanced": {
       "mcpServers": [
         {
           "name": "mem0",
           "command": "python",
           "args": ["path/to/your/mcp-mem0/mcp_direct.py"]
         }
       ]
     }
   }
   ```
3. **Restart VS Code** to load the configuration

See [VSCODE_SETUP.md](VSCODE_SETUP.md) for detailed instructions.

### SSE Configuration

Once you have the server running with SSE transport, you can connect to it using this configuration:

```json
{
  "mcpServers": {
    "mem0": {
      "transport": "sse",
      "url": "http://localhost:8050/sse"
    }
  }
}
```

> **Note for Windsurf users**: Use `serverUrl` instead of `url` in your configuration:
> ```json
> {
>   "mcpServers": {
>     "mem0": {
>       "transport": "sse",
>       "serverUrl": "http://localhost:8050/sse"
>     }
>   }
> }
> ```

> **Note for n8n users**: Use host.docker.internal instead of localhost since n8n has to reach outside of it's own container to the host machine:
>
> So the full URL in the MCP node would be: http://host.docker.internal:8050/sse

Make sure to update the port if you are using a value other than the default 8050.

### Python with Stdio Configuration

Add this server to your MCP configuration for Claude Desktop, Windsurf, or any other MCP client:

```json
{
  "mcpServers": {
    "mem0": {
      "command": "python",
      "args": ["main.py"],
      "env": {
        "TRANSPORT": "stdio",
        "LLM_PROVIDER": "openai",
        "LLM_BASE_URL": "https://api.openai.com/v1",
        "LLM_API_KEY": "sk-your-openai-api-key-here",
        "LLM_CHOICE": "gpt-4o-mini",
        "EMBEDDING_MODEL_CHOICE": "text-embedding-3-small",
        "DATABASE_URL": "postgresql://mem0user:mem0password@localhost:5432/mem0db"
      }
    }
  }
}
```

### Docker with Stdio Configuration

```json
{
  "mcpServers": {
    "mem0": {
      "command": "docker",
      "args": ["run", "--rm", "-i",
               "-e", "TRANSPORT",
               "-e", "LLM_PROVIDER",
               "-e", "LLM_BASE_URL",
               "-e", "LLM_API_KEY",
               "-e", "LLM_CHOICE",
               "-e", "EMBEDDING_MODEL_CHOICE",
               "-e", "DATABASE_URL",
               "mcp/mem0"],
      "env": {
        "TRANSPORT": "stdio",
        "LLM_PROVIDER": "openai",
        "LLM_BASE_URL": "https://api.openai.com/v1",
        "LLM_API_KEY": "sk-your-openai-api-key-here",
        "LLM_CHOICE": "gpt-4o-mini",
        "EMBEDDING_MODEL_CHOICE": "text-embedding-3-small",
        "DATABASE_URL": "postgresql://mem0user:mem0password@localhost:5432/mem0db"
      }
    }
  }
}
```

## Building Your Own Server

This template provides a foundation for building more complex MCP servers. To build your own:

1. Add your own tools by creating methods with the `@mcp.tool()` decorator
2. Create your own lifespan function to add your own dependencies (clients, database connections, etc.)
3. Modify the `utils.py` file for any helper functions you need for your MCP server
4. Feel free to add prompts and resources as well  with `@mcp.resource()` and `@mcp.prompt()`
