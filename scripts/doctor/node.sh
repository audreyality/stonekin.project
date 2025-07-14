#!/bin/bash
set -e

echo "🔍 Node.js Version Validation"
echo "============================="

if command -v node &> /dev/null; then
    node_version=$(node --version)
    echo "✓ Node.js installed: $node_version"
else
    echo "ℹ️  Node.js not found on host system"
    echo "   This is fine - DevContainer provides Node.js"
fi

if command -v npm &> /dev/null; then
    npm_version=$(npm --version)
    echo "✓ npm available: v$npm_version"
    
    if [ -f "package.json" ]; then
        echo "✓ package.json found - npm scripts available"
        
        # Check for required dev scripts
        required_scripts=("dev:up" "dev:shell" "dev:down" "doctor")
        for script in "${required_scripts[@]}"; do
            if npm run 2>/dev/null | grep -q "$script"; then
                echo "✓ Required script '$script' available"
            else
                echo "❌ Required script '$script' missing from package.json"
                exit 1
            fi
        done
    else
        echo "❌ package.json not found"
        exit 1
    fi
fi

echo "✅ Node.js validation passed"