#!/bin/bash
set -e

echo "🔍 Credential Files Validation"
echo "=============================="

echo "📝 Claude Directory Structure:"
if [ -d ".claude" ]; then
    echo "  ✓ .claude directory exists"
    
    if [ -f ".claude/_DOMAIN.md" ]; then
        echo "  ✓ .claude/_DOMAIN.md exists"
    else
        echo "  ❌ .claude/_DOMAIN.md missing"
        exit 1
    fi
    
    if [ -f ".claude/.gitignore" ]; then
        echo "  ✓ .claude/.gitignore exists"
    else
        echo "  ❌ .claude/.gitignore missing"
        exit 1
    fi
else
    echo "  ❌ .claude directory not found"
    exit 1
fi

echo ""
echo "📁 Memory Directory Structure:"
if [ -d ".devcontainer/memory" ]; then
    echo "  ✓ .devcontainer/memory directory exists"
    
    if [ -f ".devcontainer/memory/.gitignore" ]; then
        echo "  ✓ Memory .gitignore exists"
    else
        echo "  ❌ Memory .gitignore missing"
        exit 1
    fi
else
    echo "  ❌ .devcontainer/memory directory not found"
    exit 1
fi

echo "✅ Credential files validation passed"