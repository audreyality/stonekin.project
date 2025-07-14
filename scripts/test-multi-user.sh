#!/bin/bash
set -e

echo "🧪 Multi-User Container Testing"
echo "==============================="

# Test users
test_users=("alice" "bob" "claude-test")

for user in "${test_users[@]}"; do
    echo ""
    echo "🔍 Testing user: $user"
    echo "======================"
    
    # Initialize user
    echo "  📝 Initializing user..."
    CLAUDE_USER="$user" CLAUDE_EMAIL="$user@test.local" ./scripts/init-dev.sh
    
    # Test container startup
    echo "  🚀 Testing container startup..."
    if CLAUDE_USER="$user" npm run dev:up; then
        echo "  ✓ Container started successfully"
        
        # Test container validation
        echo "  🔍 Running container validation..."
        CLAUDE_USER="$user" docker-compose -f .devcontainer/docker-compose.yml exec -T "${user}-stonekin-dev" bash -c '
            cd /workspace
            echo "Container validation for user: $CLAUDE_USER"
            
            # Run all container doctor scripts
            for script in /workspace/.devcontainer/scripts/doctor/*.sh; do
                if [ -f "$script" ] && [ -x "$script" ]; then
                    echo "Running $(basename "$script")..."
                    "$script"
                fi
            done
        '
        
        # Test isolation
        echo "  🔒 Testing isolation..."
        expected_memory="/memory/$user"
        actual_memory=$(CLAUDE_USER="$user" docker-compose -f .devcontainer/docker-compose.yml exec -T "${user}-stonekin-dev" bash -c 'echo $MEMORY_FILE_PATH')
        
        if [ "$actual_memory" = "$expected_memory" ]; then
            echo "  ✓ Memory isolation correct"
        else
            echo "  ❌ Memory isolation failed"
            echo "    Expected: $expected_memory"
            echo "    Actual: $actual_memory"
            exit 1
        fi
        
        # Stop container
        echo "  🛑 Stopping container..."
        CLAUDE_USER="$user" npm run dev:down
        
        echo "  ✅ User $user validation passed"
    else
        echo "  ❌ Container failed to start for user $user"
        exit 1
    fi
done

echo ""
echo "🧹 Cleaning up test users..."
for user in "${test_users[@]}"; do
    rm -rf ".claude/$user"
    # Remove user-specific volumes
    docker volume rm "${user}-stonekin-history" 2>/dev/null || true
done

echo ""
echo "🎉 Multi-user testing completed successfully!"