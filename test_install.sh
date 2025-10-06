#!/bin/bash

# Test script to validate the Immutable Stack install process
# This script only tests the basic installation, not additional features

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

echo ""
echo "🎉 Install test passed! Basic installation is working correctly."
echo "=========================================="
