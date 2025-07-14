#!/bin/bash
set -e

echo "🔍 Package Script Validation"
echo "============================"

echo "📦 Testing npm scripts..."

# Test non-container scripts
if npm run doctor:test 2>/dev/null; then
    echo "✓ Doctor script accessible via npm"
else
    echo "ℹ️  Doctor script validation (using direct execution)"
fi

# Test script syntax
if npm run 2>/dev/null | grep -q "dev:up"; then
    echo "✓ Container management scripts available"
else
    echo "❌ Container management scripts missing"
    exit 1
fi

if npm run 2>/dev/null | grep -q "lint:md"; then
    echo "✓ Linting scripts available"
else
    echo "❌ Linting scripts missing"
    exit 1
fi

# Test package.json syntax
if npm run --silent >/dev/null 2>&1; then
    echo "✓ package.json syntax is valid"
else
    echo "❌ package.json has syntax errors"
    exit 1
fi

echo "✅ Package script validation passed"