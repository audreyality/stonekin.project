#!/bin/bash
set -e

echo "🔍 Docker Compose Validation"
echo "============================"

if command -v docker-compose &> /dev/null; then
    compose_version=$(docker-compose --version)
    echo "✓ Docker Compose installed: $compose_version"
else
    echo "❌ Docker Compose not found in PATH"
    exit 1
fi

if [ -f ".devcontainer/docker-compose.yml" ]; then
    echo "✓ DevContainer compose file exists"
    
    # Basic syntax validation (without CLAUDE_USER)
    if docker-compose -f .devcontainer/docker-compose.yml config --quiet 2>/dev/null; then
        echo "✓ Docker Compose basic syntax is valid"
    else
        echo "⚠️  Docker Compose syntax validation requires CLAUDE_USER"
    fi
    
    # Multi-user validation if CLAUDE_USER is set
    if [ -n "$CLAUDE_USER" ]; then
        echo ""
        echo "🔍 Multi-User Configuration Validation"
        echo "======================================"
        
        if docker-compose -f .devcontainer/docker-compose.yml config >/dev/null 2>&1; then
            echo "✓ Docker Compose configuration valid for CLAUDE_USER=$CLAUDE_USER"
            
            expected_mount="/.claude/${CLAUDE_USER}/"
            if docker-compose -f .devcontainer/docker-compose.yml config | grep -q "$expected_mount"; then
                echo "✓ User-specific mount configuration found"
            else
                echo "⚠️  User-specific mount configuration not found"
            fi
        else
            echo "❌ Docker Compose configuration invalid with CLAUDE_USER=$CLAUDE_USER"
            exit 1
        fi
    fi
else
    echo "❌ DevContainer compose file not found"
    exit 1
fi

echo "✅ Docker Compose validation passed"