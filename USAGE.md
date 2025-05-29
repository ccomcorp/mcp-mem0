# MCP Mem0 Server Usage Guide

This guide shows you how to use the MCP Mem0 server for long-term memory management.

## Quick Start

1. **Start the server** using Docker Compose:
   ```bash
   docker-compose up
   ```

2. **Verify the server is running**:
   ```bash
   python test_mcp_server.py
   ```

3. **Configure your MCP client** to connect to `http://localhost:8050/sse`

## Available Tools

### 1. save_memory

Store information in long-term memory with semantic indexing.

**Parameters:**
- `memory` (string): The information to store

**Example:**
```json
{
  "tool": "save_memory",
  "arguments": {
    "memory": "User prefers dark mode and uses VS Code for development"
  }
}
```

**Response:**
```json
{
  "success": true,
  "message": "Memory saved successfully",
  "memory_id": "uuid-here"
}
```

### 2. get_all_memories

Retrieve all stored memories for comprehensive context.

**Parameters:** None

**Example:**
```json
{
  "tool": "get_all_memories",
  "arguments": {}
}
```

**Response:**
```json
{
  "memories": [
    {
      "id": "uuid-1",
      "content": "User prefers dark mode and uses VS Code for development",
      "timestamp": "2025-01-01T12:00:00Z"
    },
    {
      "id": "uuid-2", 
      "content": "User is working on a Python project with FastAPI",
      "timestamp": "2025-01-01T12:05:00Z"
    }
  ]
}
```

### 3. search_memories

Find relevant memories using semantic search.

**Parameters:**
- `query` (string): Search query

**Example:**
```json
{
  "tool": "search_memories",
  "arguments": {
    "query": "development preferences"
  }
}
```

**Response:**
```json
{
  "memories": [
    {
      "id": "uuid-1",
      "content": "User prefers dark mode and uses VS Code for development",
      "relevance_score": 0.95,
      "timestamp": "2025-01-01T12:00:00Z"
    }
  ]
}
```

## Integration Examples

### Claude Desktop Configuration

Add this to your Claude Desktop MCP configuration:

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

### Windsurf Configuration

```json
{
  "mcpServers": {
    "mem0": {
      "transport": "sse",
      "serverUrl": "http://localhost:8050/sse"
    }
  }
}
```

## Common Use Cases

### 1. User Preferences
Store user preferences that should persist across conversations:
```
save_memory("User prefers concise explanations and code examples")
```

### 2. Project Context
Remember project details:
```
save_memory("Working on a React e-commerce app with TypeScript and Tailwind CSS")
```

### 3. Learning Progress
Track learning and skill development:
```
save_memory("User is learning Docker and has completed basic container tutorials")
```

### 4. Conversation History
Store important conversation outcomes:
```
save_memory("Resolved database connection issue by updating connection string format")
```

## Troubleshooting

### Server Not Starting
- Check if ports 5432 and 8050 are available
- Verify Docker is running
- Check `.env` file has valid OpenAI API key

### Memory Not Saving
- Verify OpenAI API key is valid
- Check database connection in logs
- Ensure PostgreSQL container is healthy

### Search Not Working
- Verify embeddings are being generated
- Check if memories exist with `get_all_memories`
- Try different search terms

## Monitoring

### Check Server Status
```bash
curl http://localhost:8050/sse
```

### View Container Logs
```bash
docker-compose logs -f
```

### Check Database
```bash
docker exec -it mcp-mem0-postgres-1 psql -U mem0user -d mem0db -c "SELECT COUNT(*) FROM memories;"
```

## Best Practices

1. **Be Specific**: Store specific, actionable information rather than vague statements
2. **Use Context**: Include relevant context when storing memories
3. **Regular Cleanup**: Periodically review and clean up outdated memories
4. **Search Effectively**: Use descriptive search terms for better results
5. **Test Regularly**: Use the test script to verify functionality

## Advanced Configuration

### Custom Database
Update `DATABASE_URL` in `.env` to use your own PostgreSQL instance:
```bash
DATABASE_URL=postgresql://user:password@host:port/database
```

### Different LLM Provider
Configure alternative providers in `.env`:
```bash
LLM_PROVIDER=openrouter
LLM_BASE_URL=https://openrouter.ai/api/v1
LLM_API_KEY=your-openrouter-key
```

### Memory Configuration
Customize Mem0 behavior by modifying the configuration in `src/main.py`.
