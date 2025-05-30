# MCP Mem0 Server Makefile
# Simple commands to manage the MCP server

.PHONY: start stop restart logs test clean help

# Default target
help:
	@echo "MCP Mem0 Server Commands:"
	@echo "========================"
	@echo "  make start    - Smart start (checks existing containers)"
	@echo "  make stop     - Stop the MCP server"
	@echo "  make restart  - Restart the MCP server"
	@echo "  make logs     - View server logs"
	@echo "  make test     - Test the server"
	@echo "  make clean    - Clean up containers and volumes"
	@echo "  make help     - Show this help"

# Start the server with smart container management
start:
	@python start_server.py

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
