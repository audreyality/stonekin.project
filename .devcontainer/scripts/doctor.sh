#!/bin/bash
set -e

# Doctor script with container detection and iteration logic
# Works both on host and inside container

# Determine if we're running inside the container
if [ -d "/workspace" ]; then
    # Inside container - run container doctor scripts
    SCRIPT_DIR="/workspace/scripts/doctor"
    echo "🔍 DevContainer Doctor - Container Validation"
    echo "============================================="
else
    # On host - run host doctor scripts
    SCRIPT_DIR="scripts/doctor"
    echo "🔍 DevContainer Doctor - Host Validation"
    echo "========================================"
fi

echo ""

# Parse command line arguments
INCLUDE_DEVCONTAINER=false
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --include-devcontainer)
            INCLUDE_DEVCONTAINER=true
            shift
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--include-devcontainer] [--verbose]"
            exit 1
            ;;
    esac
done

# Run doctor scripts in the appropriate directory
failures=0

if [ -d "$SCRIPT_DIR" ]; then
    for script in "$SCRIPT_DIR"/*.sh; do
        if [ -f "$script" ] && [ -x "$script" ]; then
            echo ""
            echo "Running $(basename "$script")..."
            if [ "$VERBOSE" = true ]; then
                if ! "$script"; then
                    ((failures++))
                fi
            else
                # Run script and capture both output and exit code
                script_output=$("$script" 2>&1)
                script_exit_code=$?
                echo "$script_output" | grep -E "(✓|❌|⚠️|ℹ️)"
                if [ $script_exit_code -ne 0 ]; then
                    ((failures++))
                fi
            fi
        fi
    done
else
    echo "❌ Doctor scripts directory not found: $SCRIPT_DIR"
    exit 1
fi

if [ $failures -gt 0 ]; then
    echo ""
    echo "❌ $failures validation(s) failed"
    exit 1
fi

echo ""
echo "✅ All validations passed"

# If on host and --include-devcontainer flag is set, run container validation too
if [ ! -d "/workspace" ] && [ "$INCLUDE_DEVCONTAINER" = true ]; then
    if [ -n "$CLAUDE_USER" ]; then
        echo ""
        echo "🚀 Running DevContainer validation..."
        
        # Start container if not running
        if ! docker-compose -f .devcontainer/docker-compose.yml ps | grep -q "Up"; then
            echo "  Starting DevContainer..."
            npm run dev:up
            container_started=true
        else
            container_started=false
        fi
        
        # Run container doctor script
        echo ""
        docker-compose -f .devcontainer/docker-compose.yml exec -T claude-stonekin bash -c '
            cd /workspace
            if [ -f "scripts/doctor.sh" ] && [ -x "scripts/doctor.sh" ]; then
                echo "Running container validation..."
                ./scripts/doctor.sh
            else
                echo "❌ Container doctor script not found"
                exit 1
            fi
        '
        
        container_exit_code=$?
        
        # Stop container if we started it
        if [ "$container_started" = true ]; then
            echo ""
            echo "🛑 Stopping DevContainer..."
            npm run dev:down
        fi
        
        if [ $container_exit_code -ne 0 ]; then
            echo "❌ Container validation failed"
            exit 1
        fi
        
        echo "✅ Container validation passed"
    else
        echo ""
        echo "ℹ️  Skipping DevContainer validation (CLAUDE_USER not set)"
        echo "   Set CLAUDE_USER environment variable to test container functionality"
    fi
fi

echo ""
echo "🎉 Doctor validation complete!"