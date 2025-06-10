#!/bin/bash

# Check that $SOURCE_DIR and $INSTALL_PREFIX are set
if [ -z "$SOURCE_DIR" ]; then
    echo "SOURCE_DIR is not set"
    exit 1
fi

if [ -z "$INSTALL_PREFIX" ]; then
    echo "INSTALL_PREFIX is not set"
    exit 1
fi

echo "Removing jq..."

# Remove the symlink
if [ -L "$INSTALL_PREFIX/bin/jq" ]; then
    echo "Removing symlink: $INSTALL_PREFIX/bin/jq"
    unlink "$INSTALL_PREFIX/bin/jq"
fi

# Remove the binary
binary_path="$SOURCE_DIR/jq-linux-amd64"
if [ -f "$binary_path" ]; then
    echo "Removing jq binary: $binary_path"
    rm -f "$binary_path"
fi

echo "jq removed successfully." 