#!/bin/bash

# Update SHA-256 hash in immutable.rb from the actual tar.gz file
VERSION=$(node -p "require('./package.json').version")
TARFILE="ImmutableStack-v$VERSION.tar.gz"

echo "Updating SHA-256 hash for $TARFILE..."

# Check if tar file exists
if [ ! -f "$TARFILE" ]; then
    echo "Error: Tar file $TARFILE not found!"
    exit 1
fi

# Calculate SHA-256 hash of the tar file
NEW_SHA=$(shasum -a 256 "$TARFILE" | cut -d' ' -f1)

echo "Calculated SHA-256: $NEW_SHA"

# Update the SHA in immutable.rb
sed -i.bak "s/sha256 \".*\"/sha256 \"$NEW_SHA\"/" immutable.rb

# Remove backup file
rm -f immutable.rb.bak

echo "SHA-256 hash updated successfully in immutable.rb!"
