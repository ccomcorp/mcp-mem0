# MCP Mem0 Server Makefile
# Simple commands to manage the MCP server

.PHONY: start stop restart logs test clean help

# Default target
help:
	@echo "MCP Mem0 Server Commands:"
	@echo "========================"
	@echo "  make start    - Start the MCP server (one command setup)"
	@echo "  make stop     - Stop the MCP server"
	@echo "  make restart  - Restart the MCP server"
	@echo "  make logs     - View server logs"
	@echo "  make test     - Test the server"
	@echo "  make clean    - Clean up containers and volumes"
	@echo "  make help     - Show this help"

# Start the server with full setup
start:
	@echo "🚀 Starting MCP Mem0 Server..."
	@if not exist .env ( \
		echo 📝 Creating .env file... && \
		copy .env.example .env 2>nul || ( \
			echo # OpenAI Configuration > .env && \
			echo OPENAI_API_KEY=your-openai-api-key-here >> .env && \
			echo. >> .env && \
			echo # Database Configuration >> .env && \
			echo DATABASE_URL=postgresql://mem0user:mem0password@localhost:5432/mem0db >> .env && \
			echo. >> .env && \
			echo # Server Configuration >> .env && \
			echo TRANSPORT=sse >> .env && \
			echo PORT=8050 >> .env \
		) && \
		echo ⚠️  Please edit .env file and add your OpenAI API key \
	)
	@docker-compose down --remove-orphans 2>nul || echo ""
	@docker-compose up -d
	@echo "⏳ Waiting for services to start..."
	@timeout /t 10 /nobreak >nul 2>&1 || sleep 10 2>/dev/null || echo "Waiting..."
	@echo "✅ MCP server should be ready at http://localhost:8050/sse"

# Stop the server
stop:
	@echo "🛑 Stopping MCP Mem0 Server..."
	@docker-compose down

# Restart the server
restart: stop start

# View logs
logs:
	@docker-compose logs -f

# Test the server
test:
	@echo "🧪 Testing MCP server..."
	@python test_mcp_server.py 2>nul || echo "⚠️  Test failed - check your setup"

# Clean up everything
clean:
	@echo "🧹 Cleaning up containers and volumes..."
	@docker-compose down -v --remove-orphans
	@docker system prune -f
