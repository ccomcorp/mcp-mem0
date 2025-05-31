@echo off
echo 🚀 Auto-Starting MCP Mem0 Server...
echo ====================================

REM Change to the project directory
cd /d "H:\mcp-mem0"

REM Start containers in detached mode (background)
echo 📦 Starting Docker containers...
docker-compose up -d

REM Wait a moment for containers to start
echo ⏳ Waiting for services to initialize...
timeout /t 5 /nobreak >nul

REM Check if containers are running
echo 🔍 Checking container status...
docker-compose ps

echo.
echo ✅ MCP Mem0 Server Auto-Start Complete!
echo 📍 Server URL: http://localhost:8050/sse
echo 🔧 VS Code Config: Use mcp_direct.py for STDIO mode
echo.
echo 💡 Containers will now auto-restart if they crash or if Docker restarts
echo 🛑 To stop: docker-compose down
