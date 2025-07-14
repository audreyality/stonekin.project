#!/bin/bash
set -e

echo "🚀 Starting data migration to new structure..."

# Check for existing files to migrate
if [ -f ".gitconfig-claude" ] || [ -d ".ssh-claude" ] || [ -d "memory" ]; then
    echo "📦 Found existing data to migrate"
    
    # Create claudreyality user directory if it doesn't exist
    mkdir -p .claude/claudreyality
    
    # Migrate git config
    if [ -f ".gitconfig-claude" ]; then
        echo "  Moving .gitconfig-claude → .claude/claudreyality/.gitconfig"
        mv .gitconfig-claude .claude/claudreyality/.gitconfig
    fi
    
    # Migrate SSH keys
    if [ -d ".ssh-claude" ]; then
        echo "  Moving .ssh-claude/ → .claude/claudreyality/.ssh/"
        mv .ssh-claude .claude/claudreyality/.ssh
        
        # Preserve permissions
        chmod 700 .claude/claudreyality/.ssh
        find .claude/claudreyality/.ssh -name "id_*" -not -name "*.pub" -exec chmod 600 {} \;
        find .claude/claudreyality/.ssh -name "*.pub" -exec chmod 644 {} \;
    fi
    
    # Migrate memory directory
    if [ -d "memory" ]; then
        echo "  Moving memory/ → .devcontainer/memory/"
        # Copy contents, preserving existing .devcontainer/memory structure
        cp -r memory/* .devcontainer/memory/ 2>/dev/null || true
        
        # Move CLAUDE.md to new location
        if [ -f "memory/CLAUDE.md" ]; then
            mv memory/CLAUDE.md .devcontainer/memory/CLAUDE.md
        fi
        
        # Remove old memory directory
        rm -rf memory
    fi
    
    echo "✅ Data migration completed"
else
    echo "ℹ️  No existing data found to migrate"
fi