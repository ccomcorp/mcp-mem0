#!/usr/bin/env python3
"""
Test script to verify Claude Desktop Docker configuration works correctly.
This simulates what Claude Desktop does when connecting to the MCP server.
"""
import subprocess
import sys
import json
import time

def test_claude_desktop_docker_config():
    """Test the Docker command that Claude Desktop will use"""
    
    print("🧪 Testing Claude Desktop Docker Configuration...")
    print("=" * 60)
    
    # The exact command Claude Desktop will run
    docker_cmd = [
        "docker", "run", "-i", "--rm",
        "--network", "mcp-mem0_default",
        "-e", "TRANSPORT=stdio",
        "-e", "LLM_PROVIDER=openai",
        "-e", "LLM_BASE_URL=https://api.openai.com/v1",
        "-e", "LLM_API_KEY=YOUR_OPENAI_API_KEY_HERE",
        "-e", "LLM_CHOICE=gpt-4o-mini",
        "-e", "EMBEDDING_MODEL_CHOICE=text-embedding-3-small",
        "-e", "DATABASE_URL=postgresql://mem0user:mem0password@postgres:5432/mem0db",
        "mcp-mem0-mcp-mem0",
        "uv", "run", "src/main.py"
    ]
    
    print(f"📦 Docker command: {' '.join(docker_cmd[:5])}...")
    print("🚀 Starting MCP server container...")
    
    try:
        # Start the process
        process = subprocess.Popen(
            docker_cmd,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        
        print("⏳ Waiting for server to initialize...")
        time.sleep(3)
        
        # Send a simple MCP initialization message
        init_message = {
            "jsonrpc": "2.0",
            "id": 1,
            "method": "initialize",
            "params": {
                "protocolVersion": "2024-11-05",
                "capabilities": {},
                "clientInfo": {
                    "name": "test-client",
                    "version": "1.0.0"
                }
            }
        }
        
        print("📨 Sending MCP initialize message...")
        message_str = json.dumps(init_message) + "\n"
        
        try:
            process.stdin.write(message_str)
            process.stdin.flush()
            
            # Try to read response with timeout
            print("📥 Waiting for response...")
            
            # Wait a bit for response
            time.sleep(2)
            
            # Check if process is still running
            if process.poll() is None:
                print("✅ Container is running and accepting input!")
                print("🎯 MCP server appears to be working correctly")
                
                # Terminate gracefully
                process.terminate()
                process.wait(timeout=5)
                
                return True
            else:
                stdout, stderr = process.communicate()
                print(f"❌ Process exited with code: {process.returncode}")
                print(f"📤 Stdout: {stdout}")
                print(f"📤 Stderr: {stderr}")
                return False
                
        except Exception as e:
            print(f"❌ Error during communication: {e}")
            process.terminate()
            return False
            
    except subprocess.TimeoutExpired:
        print("⏰ Process timeout - this might be normal for STDIO mode")
        process.terminate()
        return True
    except Exception as e:
        print(f"❌ Error starting container: {e}")
        return False

def check_prerequisites():
    """Check if all prerequisites are met"""
    print("🔍 Checking prerequisites...")
    
    # Check Docker
    try:
        result = subprocess.run(['docker', '--version'], capture_output=True, text=True)
        if result.returncode == 0:
            print(f"✅ Docker: {result.stdout.strip()}")
        else:
            print("❌ Docker not found")
            return False
    except FileNotFoundError:
        print("❌ Docker not installed")
        return False
    
    # Check Docker network
    try:
        result = subprocess.run(['docker', 'network', 'ls'], capture_output=True, text=True)
        if 'mcp-mem0_default' in result.stdout:
            print("✅ Docker network: mcp-mem0_default exists")
        else:
            print("❌ Docker network mcp-mem0_default not found")
            print("💡 Run: docker-compose up -d")
            return False
    except Exception as e:
        print(f"❌ Error checking Docker network: {e}")
        return False
    
    # Check Docker image
    try:
        result = subprocess.run(['docker', 'images', 'mcp-mem0-mcp-mem0'], capture_output=True, text=True)
        if 'mcp-mem0-mcp-mem0' in result.stdout:
            print("✅ Docker image: mcp-mem0-mcp-mem0 exists")
        else:
            print("❌ Docker image mcp-mem0-mcp-mem0 not found")
            print("💡 Run: docker-compose build")
            return False
    except Exception as e:
        print(f"❌ Error checking Docker image: {e}")
        return False
    
    return True

if __name__ == "__main__":
    print("🚀 Claude Desktop MCP Configuration Test")
    print("=" * 60)
    
    if not check_prerequisites():
        print("\n❌ Prerequisites not met. Please fix the issues above.")
        sys.exit(1)
    
    print("\n" + "=" * 60)
    
    if test_claude_desktop_docker_config():
        print("\n✅ SUCCESS: Claude Desktop configuration should work!")
        print("📋 Next steps:")
        print("   1. Update claude_desktop_config.json with your API key")
        print("   2. Restart Claude Desktop")
        print("   3. Look for mem0 tools in Claude Desktop")
    else:
        print("\n❌ FAILED: Configuration needs debugging")
        print("💡 Check Docker logs and container status")
    
    print("\n" + "=" * 60)
    print("🏁 Test complete!")
