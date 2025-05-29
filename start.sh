#!/bin/bash

# MCP Mem0 Server Startup Script
# This script handles the complete setup and startup of the MCP Mem0 server

set -e  # Exit on any error

echo "🚀 Starting MCP Mem0 Server..."
echo "================================"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if .env file exists
if [ ! -f .env ]; then
    echo "📝 Creating .env file from template..."
    if [ -f .env.example ]; then
        cp .env.example .env
        echo "⚠️  Please edit .env file and add your OpenAI API key"
        echo "   OPENAI_API_KEY=your-api-key-here"
    else
        echo "❌ .env.example not found. Creating basic .env file..."
        cat > .env << EOF
# OpenAI Configuration
OPENAI_API_KEY=your-openai-api-key-here

# Database Configuration
DATABASE_URL=postgresql://mem0user:mem0password@localhost:5432/mem0db

# Server Configuration
TRANSPORT=sse
PORT=8050

# LLM Configuration
LLM_PROVIDER=openai
LLM_BASE_URL=https://api.openai.com/v1
LLM_CHOICE=gpt-4o-mini
EMBEDDING_MODEL_CHOICE=text-embedding-3-small
EOF
        echo "⚠️  Please edit .env file and add your OpenAI API key"
    fi
    echo ""
fi

# Check if OpenAI API key is set
if grep -q "your-openai-api-key-here" .env; then
    echo "⚠️  Warning: Please set your OpenAI API key in .env file"
    echo "   Edit the OPENAI_API_KEY line with your actual API key"
    echo ""
fi

# Stop any existing containers
echo "🧹 Cleaning up existing containers..."
docker-compose down --remove-orphans > /dev/null 2>&1 || true

# Start the services
echo "🐳 Starting Docker containers..."
docker-compose up -d

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 5

# Check if PostgreSQL is ready
echo "🔍 Checking PostgreSQL connection..."
for i in {1..30}; do
    if docker exec mcp-mem0-postgres-1 pg_isready -U mem0user -d mem0db > /dev/null 2>&1; then
        echo "✅ PostgreSQL is ready"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "❌ PostgreSQL failed to start"
        docker-compose logs postgres
        exit 1
    fi
    sleep 1
done

# Check if MCP server is ready
echo "🔍 Checking MCP server..."
for i in {1..30}; do
    if curl -s http://localhost:8050/sse > /dev/null 2>&1; then
        echo "✅ MCP server is ready"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "❌ MCP server failed to start"
        docker-compose logs mcp-mem0
        exit 1
    fi
    sleep 1
done

echo ""
echo "🎉 MCP Mem0 Server is running successfully!"
echo "================================"
echo "📍 Server URL: http://localhost:8050/sse"
echo "🔧 PostgreSQL: localhost:5432"
echo ""
echo "📋 Available commands:"
echo "  • View logs:    docker-compose logs -f"
echo "  • Stop server:  docker-compose down"
echo "  • Restart:      ./start.sh"
echo ""
echo "🔗 For VS Code integration, use this URL in your MCP configuration:"
echo "   http://localhost:8050/sse"
echo ""

# Optional: Run test if available
if [ -f "test_mcp_server.py" ]; then
    echo "🧪 Running quick test..."
    python test_mcp_server.py || echo "⚠️  Test failed - check your OpenAI API key"
fi
