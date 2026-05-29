#!/bin/bash
# Uninstall Claude CLI

if [ -z "$INSTALL_PREFIX" ]; then
    echo "INSTALL_PREFIX is not set"
    exit 1
fi

echo "Removing claude CLI..."

# Remove binaries installed by npm --prefix
for bin in claude; do
    bin_path="$INSTALL_PREFIX/bin/$bin"
    if [ -e "$bin_path" ] || [ -L "$bin_path" ]; then
        echo "Removing: $bin_path"
        rm -f "$bin_path"
    fi
done

# Remove npm package tree
pkg_dir="$INSTALL_PREFIX/lib/node_modules/@anthropic-ai/claude-code"
if [ -d "$pkg_dir" ]; then
    echo "Removing package: $pkg_dir"
    rm -rf "$pkg_dir"
fi

echo "claude CLI removed."
