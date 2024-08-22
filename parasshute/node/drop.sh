#!/bin/bash

# if `node` exists, return 0
# Use install path only to check the binary
path=$INSTALL_PREFIX/bin:$PATH
node_path=$(PATH=$path command -v node)
test -z "$node_path" || {
    echo "NodeJS is already here: $node_path"
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

wget https://nodejs.org/dist/v20.17.0/node-v20.17.0-linux-x64.tar.xz || {
    echo "!Failed to download nodejs archive"
    exit 1
}
tar -xvf node-v20.17.0-linux-x64.tar.xz || { echo "!Failed to extract"; exit 1; }

mkdir -p $INSTALL_PREFIX/bin
ln -s $PWD/node-v20.17.0-linux-x64/bin/* $INSTALL_PREFIX/bin
popd

echo "Node version:"
node --version || { return 1; }
echo "NPM version:"
npm --version || { return 1; }
