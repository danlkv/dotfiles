#!/bin/bash

# if `jq` exists, return 0
# Use install path only to check the binary
path=$INSTALL_PREFIX/bin:$PATH
jq_path=$(PATH=$path command -v jq)
test -z "$jq_path" || {
    echo "jq is already here: $jq_path"
    exit 0
}

# Check that $SOURCE_DIR and $INSTALL_PREFIX are set
if [ -z "$SOURCE_DIR" ]; then
    echo "SOURCE_DIR is not set"
    exit 1
fi

if [ -z "$INSTALL_PREFIX" ]; then
    echo "INSTALL_PREFIX is not set"
    exit 1
fi

# DEPEND:
# - wget

# -- Install
echo "Downloading jq into SOURCE_DIR: $SOURCE_DIR"
echo "Prefix is INSTALL_PREFIX: $INSTALL_PREFIX"

mkdir -p $SOURCE_DIR
pushd $SOURCE_DIR

# Download jq binary from the latest release
binary_name=jq-linux-amd64
if [ ! -f $binary_name ]; then
    echo "Downloading jq binary: $binary_name"
    wget https://github.com/jqlang/jq/releases/download/jq-1.8.0/$binary_name || {
        echo "!Failed to download jq binary"
        exit 1
    }
else
    echo "Binary already exists: $binary_name"
fi

# Make the binary executable
chmod +x $binary_name

mkdir -p $INSTALL_PREFIX/bin

# Create symlink to the jq binary
ln -sf $PWD/$binary_name $INSTALL_PREFIX/bin/jq

popd

echo "jq usage: https://jqlang.org/"
echo "jq version:"

jq --version || { return 1; } 