#!/bin/bash

# if `rg` exists, return 0
# Use install path only to check the binary
path=$INSTALL_PREFIX/bin:$PATH
path=$(PATH=$path command -v rg)
test -z "$path" || {
    echo "RipGrep is already here: $path"
    exit 0
}

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
echo "Downloading node source into SOURCE_DIR: $SOURCE_DIR"
echo "Prefix is INSTALL_PREFIX: $INSTALL_PREFIX"

mkdir -p $SOURCE_DIR
pushd $SOURCE_DIR

wget https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep-14.1.0-x86_64-unknown-linux-musl.tar.gz || {
    echo "!Failed to download ripgrep archive"
    exit 1
}
tar -xvf ripgrep-14.1.0-x86_64-unknown-linux-musl.tar.gz || { echo "!Failed to extract"; exit 1; }

mkdir -p $INSTALL_PREFIX/bin
ln -s $PWD/ripgrep-14.1.0-x86_64-unknown-linux-musl/bin/* $INSTALL_PREFIX/bin
popd

echo "RipGrep version:"
rg --version || { return 1; }
