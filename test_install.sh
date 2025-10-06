#!/bin/bash

# Test script to validate the Immutable Stack install process
# This script tests the core installation flow as defined in the bash profile

set -e  # Exit on any error

echo "🧪 Testing Immutable Stack Install Process"
echo "=========================================="

# Test 1: Verify immutable command is available
echo "Test 1: Checking if immutable command is available..."
if ! command -v immutable &> /dev/null; then
    echo "❌ FAIL: immutable command not found"
    exit 1
fi
echo "✅ PASS: immutable command is available"

# Test 2: Test core installation
echo "Test 2: Testing core installation (immutable -install)..."
if ! immutable -install; then
    echo "❌ FAIL: Core installation failed"
    exit 1
fi
echo "✅ PASS: Core installation completed"

# Test 3: Test devkit installation
echo "Test 3: Testing devkit installation (immutable -devkit)..."
if ! immutable -devkit; then
    echo "❌ FAIL: Devkit installation failed"
    exit 1
fi
echo "✅ PASS: Devkit installation completed"

# Test 4: Test project initialization
echo "Test 4: Testing project initialization..."
TEST_PROJECT_NAME="test_project_$(date +%s)"
if ! immutable -init "$TEST_PROJECT_NAME"; then
    echo "❌ FAIL: Project initialization failed"
    exit 1
fi
echo "✅ PASS: Project initialization completed"

# Test 5: Verify project structure was created
echo "Test 5: Verifying project structure..."
PROJECT_DIR="${TEST_PROJECT_NAME}_umbrella"
if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ FAIL: Project directory $PROJECT_DIR not created"
    exit 1
fi

# Check for essential files
ESSENTIAL_FILES=("mix.exs" "package.json" "README.md")
for file in "${ESSENTIAL_FILES[@]}"; do
    if [ ! -f "$PROJECT_DIR/$file" ]; then
        echo "❌ FAIL: Essential file $file not found in project"
        exit 1
    fi
done
echo "✅ PASS: Project structure verified"

# Test 6: Test genfile creation
echo "Test 6: Testing genfile creation..."
if ! immutable -genfile test_gen; then
    echo "❌ FAIL: Genfile creation failed"
    exit 1
fi
echo "✅ PASS: Genfile creation completed"

# Cleanup
echo "Cleaning up test project..."
rm -rf "$PROJECT_DIR"

echo ""
echo "🎉 All tests passed! Install process is working correctly."
echo "=========================================="
