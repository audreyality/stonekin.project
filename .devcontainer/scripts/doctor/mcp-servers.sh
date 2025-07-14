#!/bin/bash
set -e
cd /workspace

echo "🔍 MCP Server Configuration Validation"
echo "======================================"

if [ -f ".devcontainer/.mcp.json" ]; then
    echo "✓ MCP configuration file exists"
    
    # Validate JSON syntax
    if command -v python3 &> /dev/null; then
        if python3 -m json.tool .devcontainer/.mcp.json >/dev/null 2>&1; then
            echo "✓ MCP configuration is valid JSON"
        else
            echo "❌ MCP configuration has syntax errors"
            exit 1
        fi
    fi
else
    echo "❌ MCP configuration file not found"
    exit 1
fi

# Check basic-memory server availability
if command -v basic-memory &> /dev/null; then
    echo "✓ basic-memory MCP server available"
else
    echo "❌ basic-memory MCP server not found"
    echo "   Install with: pip3 install --user basic-memory"
    exit 1
fi

# Check sequential-thinking server availability  
if command -v sequential-thinking &> /dev/null; then
    echo "✓ sequential-thinking MCP server available"
elif [ -f "/usr/local/lib/node_modules/@modelcontextprotocol/server-sequential-thinking/dist/index.js" ]; then
    echo "✓ sequential-thinking MCP server available (via node)"
else
    echo "❌ sequential-thinking MCP server not found"
    echo "   Install with: npm install -g @modelcontextprotocol/server-sequential-thinking"
    exit 1
fi

echo "✅ MCP server validation passed"