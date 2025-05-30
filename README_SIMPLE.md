# MCP Server for Mem0

Model Context Protocol (MCP) server that integrates long term memory into AI agents with Mem0.

## Environment Variables

TRANSPORT=stdio
LLM_PROVIDER=openai
LLM_BASE_URL=https://api.openai.com/v1
LLM_API_KEY=sk-your-openai-api-key-here
LLM_CHOICE=gpt-4o-mini
EMBEDDING_MODEL_CHOICE=text-embedding-3-small
DATABASE_URL=postgresql://mem0user:mem0password@localhost:5432/mem0db

## Installation

1. Clone this repository
2. Configure the environment variables above
3. Run with: `python main.py`

## Features

- Save memories
- Retrieve memories  
- Search memories
