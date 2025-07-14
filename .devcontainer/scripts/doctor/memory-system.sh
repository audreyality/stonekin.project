#!/bin/bash
set -e
cd /workspace

echo "🔍 Memory System Validation"
echo "==========================="

if [ -d "/memory" ]; then
    echo "✓ Root memory directory exists"
else
    echo "❌ Root memory directory not found"
    exit 1
fi

if [ -n "$MEMORY_FILE_PATH" ] && [ -d "$MEMORY_FILE_PATH" ]; then
    echo "✓ User memory directory accessible: $MEMORY_FILE_PATH"
    
    # Test write permissions
    test_file="$MEMORY_FILE_PATH/.doctor-test-$$"
    if echo "test" > "$test_file" 2>/dev/null; then
        rm -f "$test_file"
        echo "✓ Memory directory is writable"
    else
        echo "❌ Memory directory is not writable"
        exit 1
    fi
else
    echo "⚠️  User memory directory will be created on first use"
fi

# Verify memory system doesn't interfere with workspace
if [ ! -d "/workspace/memory" ]; then
    echo "✓ Memory system properly isolated from workspace"
else
    echo "⚠️  Memory directory exists in workspace (should be external mount)"
fi

echo "✅ Memory system validation passed"