#!/bin/bash
set -e

echo "🧪 Stonekin DevContainer - Complete Test Suite"
echo "=============================================="
echo ""

# Initialize counters
total_tests=0
passed_tests=0
failed_tests=0

# Test tracking function
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    echo ""
    echo "▶️  $test_name"
    echo "$(printf '=%.0s' {1..50})"
    
    ((total_tests++))
    
    if eval "$test_command"; then
        echo "✅ PASSED: $test_name"
        ((passed_tests++))
    else
        echo "❌ FAILED: $test_name"
        ((failed_tests++))
        return 1
    fi
}

# Phase 1: Basic Environment Validation
echo "🏠 Phase 1: Basic Environment Validation"
echo "========================================"

run_test "Host Environment Validation" "scripts/doctor.sh"

# Phase 2: Single User Container Testing
if [ -n "$CLAUDE_USER" ]; then
    echo ""
    echo "👤 Phase 2: Single User Container Testing"
    echo "========================================="
    
    run_test "Single User Container Validation" "scripts/doctor.sh --include-devcontainer"
else
    echo ""
    echo "⚠️  Phase 2: Skipping Single User Testing"
    echo "========================================="
    echo "CLAUDE_USER not set - single user container testing skipped"
    echo "Set CLAUDE_USER environment variable to test single user functionality"
fi

# Phase 3: Multi-User Container Testing
echo ""
echo "👥 Phase 3: Multi-User Container Testing"
echo "========================================"

if command -v docker &> /dev/null && docker info &> /dev/null; then
    run_test "Multi-User Container Testing" "scripts/test-multi-user.sh"
else
    echo "❌ FAILED: Multi-User Container Testing"
    echo "Docker is not available or not running"
    ((total_tests++))
    ((failed_tests++))
fi

# Phase 4: Package Management Validation
echo ""
echo "📦 Phase 4: Package Management Validation"
echo "========================================="

run_test "Package Scripts Validation" "npm run doctor:test"
run_test "Package.json Syntax" "npm run --silent >/dev/null 2>&1"

# Phase 5: Documentation Validation
echo ""
echo "📚 Phase 5: Documentation Validation"
echo "===================================="

run_test "Markdown Linting" "npm run lint:md"

# Results Summary
echo ""
echo "📊 Test Results Summary"
echo "======================"
echo "Total Tests: $total_tests"
echo "Passed: $passed_tests"
echo "Failed: $failed_tests"

if [ $failed_tests -eq 0 ]; then
    echo ""
    echo "🎉 ALL TESTS PASSED!"
    echo "✅ DevContainer environment is fully functional"
    echo "✅ Multi-user support is working correctly"
    echo "✅ Complete validation framework is operational"
    echo ""
    echo "Environment Status:"
    echo "  Docker: $(docker --version 2>/dev/null | cut -d' ' -f3 || echo 'Not available')"
    echo "  Docker Compose: $(docker-compose --version 2>/dev/null | cut -d' ' -f3 || echo 'Not available')"
    echo "  Node.js: $(command -v node >/dev/null && node --version || echo 'Not found')"
    echo "  VSCode: $(command -v code >/dev/null && echo 'Available' || echo 'Not found')"
    echo "  User ID: ${CLAUDE_USER:-'Not set'}"
    
    if [ -n "$CLAUDE_USER" ]; then
        echo "  Git Config: $([ -f ".claude/$CLAUDE_USER/.gitconfig" ] && echo 'Configured' || echo 'Missing')"
        echo "  SSH Keys: $([ -d ".claude/$CLAUDE_USER/.ssh" ] && echo 'Present' || echo 'Missing')"
    fi
    
    echo ""
    echo "🚀 Your Stonekin development environment is ready!"
    exit 0
else
    echo ""
    echo "❌ SOME TESTS FAILED"
    echo "Please review the failed tests above and address the issues"
    echo "Run individual validation commands to debug specific problems:"
    echo "  - scripts/doctor.sh (host validation)"
    echo "  - scripts/doctor.sh --include-devcontainer (container validation)"
    echo "  - scripts/test-multi-user.sh (multi-user testing)"
    exit 1
fi