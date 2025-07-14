#!/bin/bash
set -e
cd /workspace

echo "🔍 Multi-User Configuration Validation"
echo "======================================"

if [ -n "$CLAUDE_USER" ]; then
    expected_memory_path="/memory/${CLAUDE_USER}"
    if [ "$MEMORY_FILE_PATH" = "$expected_memory_path" ]; then
        echo "✓ Memory path correctly isolated: $MEMORY_FILE_PATH"
    else
        echo "❌ Memory path not user-specific"
        echo "   Expected: $expected_memory_path"
        echo "   Actual: $MEMORY_FILE_PATH"
        exit 1
    fi
    
    git_user=$(git config user.name 2>/dev/null || echo "")
    git_email=$(git config user.email 2>/dev/null || echo "")
    
    if [ -n "$git_user" ] && [ -n "$git_email" ]; then
        echo "✓ Git identity configured: $git_user <$git_email>"
    else
        echo "ℹ️  Git identity not configured (will be set when credentials are provided)"
    fi
else
    echo "❌ CLAUDE_USER not set - multi-user validation skipped"
    exit 1
fi

echo "✅ Multi-user configuration validation passed"