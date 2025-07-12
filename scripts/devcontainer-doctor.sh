#!/bin/bash

echo "🔍 Checking DevContainer Setup..."
echo ""

# Check Docker
echo "✓ Checking Docker..."
if command -v docker &> /dev/null; then
    echo "  Docker is installed: $(docker --version)"
else
    echo "  ❌ Docker is not installed or not in PATH"
    exit 1
fi

# Check Docker Compose
echo "✓ Checking Docker Compose..."
if command -v docker-compose &> /dev/null; then
    echo "  Docker Compose is installed: $(docker-compose --version)"
else
    echo "  ❌ Docker Compose is not installed"
    exit 1
fi

# Check Docker daemon
echo "✓ Checking Docker daemon..."
if docker info &> /dev/null; then
    echo "  Docker daemon is running"
else
    echo "  ❌ Docker daemon is not running. Please start Docker Desktop."
    exit 1
fi

# Check required files
echo "✓ Checking required files..."
required_files=(
    ".devcontainer/docker-compose.yml"
    ".devcontainer/Dockerfile"
    ".devcontainer/devcontainer.json"
    ".devcontainer/.mcp.json"
    ".devcontainer/_DOMAIN.md"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✓ $file exists"
    else
        echo "  ❌ $file is missing"
        exit 1
    fi
done

# Check git credentials setup
echo ""
echo "📝 Git Credentials Setup:"
echo "  For Claude to use git in the container, you need to set up:"
echo "  1. Create ~/.gitconfig-claude with Claude's git config"
echo "  2. Create ~/.ssh-claude/ directory with SSH keys"
echo ""
echo "  Example ~/.gitconfig-claude:"
echo "  [user]"
echo "      name = Claude (AI Assistant)"
echo "      email = claude@example.com"
echo ""

# Show next steps
echo "🚀 Ready to start the DevContainer!"
echo ""
echo "Next steps:"
echo "1. Set up git credentials (see above)"
echo "2. Run: npm run dev:up"
echo "3. Run: npm run dev:shell"
echo ""
echo "Or open in VSCode and click 'Reopen in Container'"