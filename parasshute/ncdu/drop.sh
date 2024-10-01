#!/bin/bash

# if `rg` exists, return 0
# Use install path only to check the binary
path=$INSTALL_PREFIX/bin:$PATH
path=$(PATH=$path command -v ncdu)
test -z "$path" || {
    echo "NCDU is already here: $path"
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

# -- Download if not exists
[ -f ncdu-2.6-linux-x86_64.tar.gz ] || wget https://dev.yorhel.nl/download/ncdu-2.6-linux-x86_64.tar.gz || {
    echo "!Failed to download ripgrep archive"
    exit 1
}
tar -xvf ncdu-2.6-linux-x86_64.tar.gz || { echo "!Failed to extract"; exit 1; }

mkdir -p $INSTALL_PREFIX/bin
ln -s $PWD/ncdu $INSTALL_PREFIX/bin/ncdu || { echo "!Failed to link"; exit 1; }
popd

echo "NCDU version:"
ncdu --version || { return 1; }
