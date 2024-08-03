#!/bin/bash

# if `fish` exists, return 0
fish_path=$(command -v fish)
echo "Fish shell path: $fish_path"
test -z "$fish_path" || {
    echo "Fish shell is already here: $fish_path"
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

echo "Installing source into SOURCE_DIR: $SOURCE_DIR"
echo "Prefix is INSTALL_PREFIX: $INSTALL_PREFIX"

# if `fish` does not exist, install it

mkdir -p $SOURCE_DIR
git clone https://github.com/fish-shell/fish-shell.git $SOURCE_DIR/fish-shell
pushd $SOURCE_DIR/fish-shell
cmake . -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX
make -j; make install

echo "Fish shell is installed at: $(command -v fish)"
