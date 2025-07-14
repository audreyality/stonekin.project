#!/bin/bash
set -e

echo "🔍 Memory System Validation"
echo "==========================="

echo "📁 Memory Directory Structure:"
if [ -d ".devcontainer/memory" ]; then
    echo "  ✓ .devcontainer/memory directory exists"
    
    if [ -f ".devcontainer/memory/.gitignore" ]; then
        echo "  ✓ Memory .gitignore exists"
    else
        echo "  ❌ Memory .gitignore missing"
        exit 1
    fi
    
    if [ -f ".devcontainer/memory/.markdownlint.json" ]; then
        echo "  ✓ Memory markdownlint config exists"
    else
        echo "  ❌ Memory markdownlint config missing"
        exit 1
    fi
    
    # Check for CLAUDE.md
    if [ -f ".devcontainer/memory/CLAUDE.md" ]; then
        echo "  ✓ Memory CLAUDE.md exists"
    else
        echo "  ⚠️  Memory CLAUDE.md not found (may not have been migrated)"
    fi
else
    echo "  ❌ .devcontainer/memory directory not found"
    exit 1
fi

echo ""
echo "🔍 Legacy Directory Cleanup:"
if [ -d "memory" ]; then
    echo "  ⚠️  Legacy memory directory still exists"
    echo "     Consider removing after migration verification"
else
    echo "  ✓ Legacy memory directory removed"
fi

if [ -f ".gitconfig-claude" ]; then
    echo "  ⚠️  Legacy .gitconfig-claude still exists"
    echo "     Should be migrated to .claude/{username}/.gitconfig"
else
    echo "  ✓ Legacy .gitconfig-claude removed"
fi

if [ -d ".ssh-claude" ]; then
    echo "  ⚠️  Legacy .ssh-claude directory still exists"
    echo "     Should be migrated to .claude/{username}/.ssh/"
else
    echo "  ✓ Legacy .ssh-claude directory removed"
fi

echo "✅ Memory system validation passed"