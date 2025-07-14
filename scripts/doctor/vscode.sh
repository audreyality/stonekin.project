#!/bin/bash
set -e

echo "🔍 VSCode Installation Validation"
echo "================================="

vscode_found=false

# Check common VSCode command names
for cmd in "code" "code-insiders" "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"; do
    if command -v "$cmd" &> /dev/null; then
        vscode_version=$("$cmd" --version 2>/dev/null | head -1 || echo "Unknown")
        echo "✓ VSCode found: $cmd (version: $vscode_version)"
        vscode_found=true
        break
    fi
done

if [ "$vscode_found" = false ]; then
    echo "⚠️  VSCode not found in PATH"
    echo "   VSCode is recommended for DevContainer development"
    echo "   Install from: https://code.visualstudio.com/"
    echo "   Or use: npm run dev:shell to access container directly"
else
    # Check for DevContainer extension
    if code --list-extensions 2>/dev/null | grep -q "ms-vscode-remote.remote-containers"; then
        echo "✓ DevContainers extension installed"
    else
        echo "⚠️  DevContainers extension not found"
        echo "   Install: ms-vscode-remote.remote-containers"
    fi
fi

echo "✅ VSCode validation completed (warnings are informational)"