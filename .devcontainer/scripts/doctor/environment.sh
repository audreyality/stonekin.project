#!/bin/bash
set -e
cd /workspace

echo "🔍 Environment Variable Validation"
echo "=================================="

if [ -z "$CLAUDE_USER" ]; then
    echo "❌ CLAUDE_USER environment variable is required"
    echo "   Set it to your preferred user identifier:"
    echo "   export CLAUDE_USER=your-identifier"
    exit 1
else
    echo "✓ CLAUDE_USER is set: $CLAUDE_USER"
fi

if [ -z "$MEMORY_FILE_PATH" ]; then
    echo "❌ MEMORY_FILE_PATH environment variable is missing"
    exit 1
else
    echo "✓ MEMORY_FILE_PATH is set: $MEMORY_FILE_PATH"
fi

echo "✅ Environment validation passed"