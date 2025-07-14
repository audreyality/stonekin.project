#!/bin/bash
set -e

echo "🔍 Required Files Validation"
echo "============================"

required_files=(
    ".devcontainer/docker-compose.yml"
    ".devcontainer/Dockerfile"
    ".devcontainer/devcontainer.json"
    ".devcontainer/.mcp.json"
    ".devcontainer/_DOMAIN.md"
    "package.json"
    "CLAUDE.md"
    "CONTRIBUTING.md"
)

required_directories=(
    "scripts/doctor"
)

echo "📄 Checking required files..."
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✓ $file exists"
    else
        echo "  ❌ $file is missing"
        exit 1
    fi
done

echo ""
echo "📁 Checking required directories..."
for dir in "${required_directories[@]}"; do
    if [ -d "$dir" ]; then
        echo "  ✓ $dir exists"
    else
        echo "  ❌ $dir is missing"
        exit 1
    fi
done

echo "✅ Required files validation passed"