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

# check if make and cmake are installed

if ! command -v make > /dev/null; then
    echo "make is not installed"
    exit 1
fi

if ! command -v cmake > /dev/null; then
    echo "cmake is not installed"
    exit 1
fi

echo "Downloading fish source into SOURCE_DIR: $SOURCE_DIR"
echo "Prefix is INSTALL_PREFIX: $INSTALL_PREFIX"

# if `fish` does not exist, install it

mkdir -p $SOURCE_DIR
git clone https://github.com/fish-shell/fish-shell.git $SOURCE_DIR/fish-shell
#
# Note: fish will port to rust in future.
#   The reason is that developers want to be trendy, and are tired of C++.
#   For me, rust is a good but heavy language (.5GB on alpine), with llvm on top.
#   The build time is longer.
#   c++ and cmake are available on most systems.
#
#   Thus, cehckout to 3.7.1
#
pushd $SOURCE_DIR/fish-shell
git checkout 3.7.1
cmake . -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX
make -j; make install

echo "Fish shell is installed at: $(command -v fish)"
