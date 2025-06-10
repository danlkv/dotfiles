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

echo "Removing GitLab CLI (glab)..."

# Remove the symlink
if [ -L "$INSTALL_PREFIX/bin/glab" ]; then
    echo "Removing symlink: $INSTALL_PREFIX/bin/glab"
    unlink "$INSTALL_PREFIX/bin/glab"
fi

# Remove the entire glab subdirectory
glab_dir="$SOURCE_DIR/glab-1.59.2"
if [ -d "$glab_dir" ]; then
    echo "Removing glab directory: $glab_dir"
    rm -rf "$glab_dir"
fi

echo "GitLab CLI removed successfully." 