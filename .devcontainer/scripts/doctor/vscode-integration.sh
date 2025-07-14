#!/bin/bash
set -e
cd /workspace

echo "🔍 VSCode Integration Validation"
echo "==============================="

# Check devcontainer.json syntax
if command -v python3 &> /dev/null; then
    if python3 -m json.tool .devcontainer/devcontainer.json >/dev/null 2>&1; then
        echo "✓ devcontainer.json is valid JSON"
    else
        echo "❌ devcontainer.json has syntax errors"
        exit 1
    fi
else
    echo "⚠️  Python not available for JSON validation"
fi

# Check workspace folder configuration
if grep -q '"workspaceFolder".*"/workspace"' .devcontainer/devcontainer.json; then
    echo "✓ workspaceFolder correctly set to /workspace"
else
    echo "⚠️  workspaceFolder not explicitly set to /workspace"
fi

# Check remoteUser configuration
if grep -q '"remoteUser".*"claudreyality"' .devcontainer/devcontainer.json; then
    echo "✓ remoteUser correctly set to claudreyality"
else
    echo "❌ remoteUser not set to claudreyality"
    exit 1
fi

# Verify we're running as the correct user
current_user=$(whoami)
if [ "$current_user" = "claudreyality" ]; then
    echo "✓ Running as correct user: $current_user"
else
    echo "❌ Running as wrong user: $current_user (should be claudreyality)"
    exit 1
fi

echo "✅ VSCode integration validation passed"