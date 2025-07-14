#!/bin/bash
set -e

echo "🔍 Docker Installation Validation"
echo "================================="

if command -v docker &> /dev/null; then
    docker_version=$(docker --version)
    echo "✓ Docker CLI installed: $docker_version"
else
    echo "❌ Docker CLI not found in PATH"
    exit 1
fi

if docker info &> /dev/null; then
    echo "✓ Docker daemon is running"
else
    echo "❌ Docker daemon is not running"
    exit 1
fi

echo "✅ Docker validation passed"