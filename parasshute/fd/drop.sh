#!/bin/bash

# if `fd` exists, return 0
# Use install path only to check the binary
path=$INSTALL_PREFIX/bin:$PATH
path=$(PATH=$path command -v fd)
test -z "$path" || {
    echo "FD is already here: $path"
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

wget https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-x86_64-unknown-linux-gnu.tar.gz || {
    echo "!Failed to download fd archive"
    exit 1
}
tar -xvf  fd-v10.2.0-x86_64-unknown-linux-gnu.tar.gz || { echo "!Failed to extract"; exit 1; }

mkdir -p $INSTALL_PREFIX/bin
ln -s $PWD/fd-v10.2.0-x86_64-unknown-linux-gnu/fd $INSTALL_PREFIX/bin/fd
popd

echo "FD version:"
fd --version || { return 1; }
