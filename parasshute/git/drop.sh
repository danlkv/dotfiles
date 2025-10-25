#!/bin/bash

set -x

# if `git` exists, still try to install
# Use install path only to check the binary
path=$INSTALL_PREFIX/bin:$PATH
exist_path=$(PATH=$path command -v git)
test -z "$exist_path" || {
    echo "Git is already here: $exist_path"
    echo "Installing anyway"
}

# Check that $SOURCE_DIR and $INSTALL_PREFIX are set
# -- Prepare

if [ -z "$SOURCE_DIR" ]; then
    echo "SOURCE_DIR is not set"
    exit 1
fi

if [ -z "$INSTALL_PREFIX" ]; then
    echo "INSTALL_PREFIX is not set"
    exit 1
fi

# DEPEND:
# - git

# -- Install
echo "Prefix is INSTALL_PREFIX: $INSTALL_PREFIX"

# ---- Download

mkdir -p $SOURCE_DIR
pushd $SOURCE_DIR
version="v2.51.0"

if [ ! -d "git" ]; then
    echo "Downloading git source into SOURCE_DIR: $SOURCE_DIR"
    git clone https://github.com/git/git.git --branch=$version --depth=5 || {
        echo "!Failed to clone the git source"
        exit 1
    }
else
    echo "Git source is already here: $(pwd)/git"
fi

# ---- Compile and install

pushd git

export PREFIX=$INSTALL_PREFIX
# -i ignores gettext dependency (and not only it)
make -j8 -i prefix=$PREFIX || {
    echo "!Failed to make"
    exit 1
}
make -i prefix=$PREFIX install || {
    echo "!Failed to install" 
    exit 1 
}

echo "Done."
git --version

