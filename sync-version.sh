#!/bin/bash

# Sync version from package.json to immutable.rb
VERSION=$(node -p "require('./package.json').version")

echo "Syncing version $VERSION to immutable.rb..."

# Update version in immutable.rb
sed -i.bak "s/version \".*\"/version \"$VERSION\"/" immutable.rb

# Update tar.gz filename in immutable.rb (strip 'v' prefix if present, then add single 'v')
VERSION_NO_V=$(echo "$VERSION" | sed 's/^v//')
sed -i.bak "s/ImmutableStack-[v]*[0-9.]*\.tar\.gz/ImmutableStack-v$VERSION_NO_V.tar.gz/" immutable.rb

# Remove backup file
rm -f immutable.rb.bak

echo "Version synced successfully!"



