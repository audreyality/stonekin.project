#!/bin/bash
set -e

echo "🔍 Host Environment Validation"
echo "=============================="

echo "📋 Environment Variables:"
if [ -n "$CLAUDE_USER" ]; then
    echo "  ✓ CLAUDE_USER is set: $CLAUDE_USER"
    
    if [[ "$CLAUDE_USER" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        echo "    ✓ CLAUDE_USER format is valid"
    else
        echo "    ⚠️  CLAUDE_USER contains special characters"
        echo "       Recommended: use only letters, numbers, hyphens, underscores"
    fi
    
    # Check if user directory exists
    if [ -d ".claude/$CLAUDE_USER" ]; then
        echo "  ✓ User credential directory exists: .claude/$CLAUDE_USER"
    else
        echo "  ℹ️  User credential directory will be created: .claude/$CLAUDE_USER"
    fi
else
    echo "  ℹ️  CLAUDE_USER not set (will be required for parameterized containers)"
fi

echo "✅ Host environment validation passed"