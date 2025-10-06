#!/bin/bash

# Get Homebrew prefix dynamically
HOMEBREW_PREFIX=$(brew --prefix)

# Get username for tap (try GitHub username from remote, then fallback to whoami)
USERNAME=$(git config --get remote.origin.url 2>/dev/null | sed -n 's/.*github\.com[:/]\([^/]*\)\/.*/\1/p')
if [ -z "$USERNAME" ]; then
    USERNAME=$(whoami)
fi
TAP_DIR="$HOMEBREW_PREFIX/Library/Taps/$USERNAME/homebrew-immutable/Formula"

# Extract version from immutable.rb
VERSION=$(grep 'version "' immutable.rb | sed 's/.*version "\(.*\)".*/\1/')
TARFILE="ImmutableStack-$VERSION.tar.gz"

echo "Building Immutable version: $VERSION"
echo "Using tar file: $TARFILE"
echo "Username: $USERNAME"
echo "Homebrew prefix: $HOMEBREW_PREFIX"
echo "Tap directory: $TAP_DIR"

# Check if tar file exists
if [ ! -f "$TARFILE" ]; then
    echo "Error: Tar file $TARFILE not found!"
    exit 1
fi

# Check if tap directory exists, create if it doesn't
if [ ! -d "$TAP_DIR" ]; then
    echo "Tap directory not found. Creating tap..."
    brew tap-new "$USERNAME/immutable"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create tap. It may already exist."
        echo "Checking if tap is installed..."
        if brew tap | grep -q "$USERNAME/immutable"; then
            echo "Tap exists but Formula directory is missing. Creating it..."
            mkdir -p "$TAP_DIR"
        else
            echo "Error: Could not create or find tap '$USERNAME/immutable'"
            exit 1
        fi
    fi
fi

# Uninstall existing version
echo "Uninstalling existing immutable..."
brew uninstall immutable 2>/dev/null || true

# Cleanup
echo "Cleaning up..."
brew cleanup

# Copy files to tap
echo "Copying files to tap..."
cp immutable.rb "$TAP_DIR/"
cp "$TARFILE" "$TAP_DIR/"

# Install from tap
echo "Installing from tap..."
brew install "$USERNAME/immutable/immutable"

echo "Build completed successfully!"
