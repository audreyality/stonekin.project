#!/bin/bash

set -e  # Exit on any error

echo "🚀 Initializing Stonekin Development Environment..."
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if we're in the project root
if [ ! -f "package.json" ] || [ ! -f "CLAUDE.md" ]; then
    echo -e "${RED}❌ Error: Please run this script from the project root directory${NC}"
    exit 1
fi

# Check if email is provided
if [ -z "${CLAUDE_EMAIL}" ]; then
    echo -e "${RED}❌ Error: CLAUDE_EMAIL environment variable is required${NC}"
    echo ""
    echo -e "${YELLOW}Basic Usage:${NC}"
    echo -e "  CLAUDE_EMAIL=claude@yourdomain.com ./scripts/init-dev.sh"
    echo ""
    echo -e "${YELLOW}Advanced Usage (with optional parameters):${NC}"
    echo -e "  CLAUDE_EMAIL=claude@yourdomain.com \\"
    echo -e "  CLAUDE_NAME='Claude Assistant' \\"
    echo -e "  GIT_EDITOR=vim \\"
    echo -e "  DEFAULT_BRANCH=main \\"
    echo -e "  ./scripts/init-dev.sh"
    exit 1
fi

# Configuration with defaults
CLAUDE_NAME="${CLAUDE_NAME:-Claude (AI Assistant)}"
GIT_EDITOR="${GIT_EDITOR:-nano}"
DEFAULT_BRANCH="${DEFAULT_BRANCH:-main}"

echo -e "${BLUE}📧 Email: ${CLAUDE_EMAIL}${NC}"
echo -e "${BLUE}👤 Name: ${CLAUDE_NAME}${NC}"
echo -e "${BLUE}✏️  Editor: ${GIT_EDITOR}${NC}"
echo -e "${BLUE}🌿 Branch: ${DEFAULT_BRANCH}${NC}"
echo ""

# Create .gitconfig-claude if it doesn't exist
if [ ! -f ".gitconfig-claude" ]; then
    echo -e "${BLUE}📝 Creating Claude's git configuration...${NC}"
    cat > .gitconfig-claude << EOF
[user]
    name = ${CLAUDE_NAME}
    email = ${CLAUDE_EMAIL}
[core]
    editor = ${GIT_EDITOR}
    autocrlf = input
[init]
    defaultBranch = ${DEFAULT_BRANCH}
[push]
    default = simple
[pull]
    rebase = false
[commit]
    gpgsign = false
[advice]
    detachedHead = false
EOF
    echo -e "${GREEN}   ✓ Created .gitconfig-claude${NC}"
else
    echo -e "${YELLOW}   ⚠ .gitconfig-claude already exists, skipping${NC}"
fi

# Create SSH keys if they don't exist
if [ ! -d ".ssh-claude" ] || [ ! -f ".ssh-claude/id_ed25519" ]; then
    echo -e "${BLUE}🔑 Generating SSH keys for Claude...${NC}"
    
    # Create directory
    mkdir -p .ssh-claude
    
    # Generate SSH key
    ssh-keygen -t ed25519 -f .ssh-claude/id_ed25519 -C "${CLAUDE_EMAIL}" -N ""
    
    # Set proper permissions
    chmod 700 .ssh-claude
    chmod 600 .ssh-claude/id_ed25519
    chmod 644 .ssh-claude/id_ed25519.pub
    
    echo -e "${GREEN}   ✓ Generated SSH key pair${NC}"
    echo -e "${BLUE}   📋 Public key (add to GitHub/GitLab):${NC}"
    echo ""
    cat .ssh-claude/id_ed25519.pub
    echo ""
else
    echo -e "${YELLOW}   ⚠ SSH keys already exist, skipping${NC}"
fi

# Create memory directory if it doesn't exist
if [ ! -d "memory" ]; then
    echo -e "${BLUE}🧠 Creating memory directory...${NC}"
    mkdir -p memory
    echo -e "${GREEN}   ✓ Created memory directory${NC}"
else
    echo -e "${YELLOW}   ⚠ Memory directory already exists${NC}"
fi

# Check Docker
echo -e "${BLUE}🐳 Checking Docker...${NC}"
if command -v docker &> /dev/null; then
    if docker info &> /dev/null; then
        echo -e "${GREEN}   ✓ Docker is running${NC}"
    else
        echo -e "${RED}   ❌ Docker daemon is not running. Please start Docker Desktop.${NC}"
        exit 1
    fi
else
    echo -e "${RED}   ❌ Docker is not installed. Please install Docker Desktop.${NC}"
    exit 1
fi

# Check Docker Compose
if command -v docker-compose &> /dev/null; then
    echo -e "${GREEN}   ✓ Docker Compose is available${NC}"
else
    echo -e "${RED}   ❌ Docker Compose is not available${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}🎉 Development environment initialized successfully!${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo -e "  1. Add the SSH public key to your Git provider (GitHub/GitLab)"
echo -e "  2. Start the development container:"
echo -e "     ${YELLOW}npm run dev:up${NC}"
echo -e "  3. Enter the container:"
echo -e "     ${YELLOW}npm run dev:shell${NC}"
echo -e "  4. Or open in VSCode and click 'Reopen in Container'"
echo ""
echo -e "${BLUE}Useful commands:${NC}"
echo -e "  ${YELLOW}npm run dev:status${NC}  - Check container status"
echo -e "  ${YELLOW}npm run dev:logs${NC}    - View container logs"
echo -e "  ${YELLOW}npm run dev:down${NC}    - Stop container"
echo -e "  ${YELLOW}npm run dev:clean${NC}   - Remove container and volumes"
echo ""