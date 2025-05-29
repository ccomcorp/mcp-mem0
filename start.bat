@echo off
setlocal enabledelayedexpansion

REM MCP Mem0 Server Startup Script for Windows
REM This script handles the complete setup and startup of the MCP Mem0 server

echo 🚀 Starting MCP Mem0 Server...
echo ================================

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not running. Please start Docker and try again.
    pause
    exit /b 1
)

REM Check if .env file exists
if not exist .env (
    echo 📝 Creating .env file from template...
    if exist .env.example (
        copy .env.example .env >nul
        echo ⚠️  Please edit .env file and add your OpenAI API key
        echo    OPENAI_API_KEY=your-api-key-here
    ) else (
        echo ❌ .env.example not found. Creating basic .env file...
        (
            echo # OpenAI Configuration
            echo OPENAI_API_KEY=your-openai-api-key-here
            echo.
            echo # Database Configuration
            echo DATABASE_URL=postgresql://mem0user:mem0password@localhost:5432/mem0db
            echo.
            echo # Server Configuration
            echo TRANSPORT=sse
            echo PORT=8050
            echo.
            echo # LLM Configuration
            echo LLM_PROVIDER=openai
            echo LLM_BASE_URL=https://api.openai.com/v1
            echo LLM_CHOICE=gpt-4o-mini
            echo EMBEDDING_MODEL_CHOICE=text-embedding-3-small
        ) > .env
        echo ⚠️  Please edit .env file and add your OpenAI API key
    )
    echo.
)

REM Check if OpenAI API key is set
findstr /C:"your-openai-api-key-here" .env >nul 2>&1
if not errorlevel 1 (
    echo ⚠️  Warning: Please set your OpenAI API key in .env file
    echo    Edit the OPENAI_API_KEY line with your actual API key
    echo.
)

REM Stop any existing containers
echo 🧹 Cleaning up existing containers...
docker-compose down --remove-orphans >nul 2>&1

REM Start the services
echo 🐳 Starting Docker containers...
docker-compose up -d

REM Wait for services to be ready
echo ⏳ Waiting for services to start...
timeout /t 5 /nobreak >nul

REM Check if PostgreSQL is ready
echo 🔍 Checking PostgreSQL connection...
set /a count=0
:check_postgres
set /a count+=1
docker exec mcp-mem0-postgres-1 pg_isready -U mem0user -d mem0db >nul 2>&1
if not errorlevel 1 (
    echo ✅ PostgreSQL is ready
    goto check_mcp
)
if !count! geq 30 (
    echo ❌ PostgreSQL failed to start
    docker-compose logs postgres
    pause
    exit /b 1
)
timeout /t 1 /nobreak >nul
goto check_postgres

:check_mcp
REM Check if MCP server is ready
echo 🔍 Checking MCP server...
set /a count=0
:check_mcp_loop
set /a count+=1
powershell -Command "try { Invoke-WebRequest -Uri 'http://localhost:8050/sse' -TimeoutSec 2 -ErrorAction Stop | Out-Null; exit 0 } catch { exit 1 }" >nul 2>&1
if not errorlevel 1 (
    echo ✅ MCP server is ready
    goto success
)
if !count! geq 30 (
    echo ❌ MCP server failed to start
    docker-compose logs mcp-mem0
    pause
    exit /b 1
)
timeout /t 1 /nobreak >nul
goto check_mcp_loop

:success
echo.
echo 🎉 MCP Mem0 Server is running successfully!
echo ================================
echo 📍 Server URL: http://localhost:8050/sse
echo 🔧 PostgreSQL: localhost:5432
echo.
echo 📋 Available commands:
echo   • View logs:    docker-compose logs -f
echo   • Stop server:  docker-compose down
echo   • Restart:      start.bat
echo.
echo 🔗 For VS Code integration, use this URL in your MCP configuration:
echo    http://localhost:8050/sse
echo.

REM Optional: Run test if available
if exist test_mcp_server.py (
    echo 🧪 Running quick test...
    python test_mcp_server.py 2>nul || echo ⚠️  Test failed - check your OpenAI API key
)

pause
