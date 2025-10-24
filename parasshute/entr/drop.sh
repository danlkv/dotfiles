#!/bin/bash


# if `entr` exists, return 0
# Use install path only to check the binary
path=$INSTALL_PREFIX/bin:$PATH
exist_path=$(PATH=$path command -v entr)
test -z "$exist_path" || {
    echo "Entr is already here: $exist_path"
    exit 0
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

nvim_install_from_source=false

# ---- Download

mkdir -p $SOURCE_DIR
pushd $SOURCE_DIR

if [ ! -d "entr" ]; then
    echo "Downloading entr source into SOURCE_DIR: $SOURCE_DIR"
    git clone https://github.com/eradman/entr.git || {
        echo "!Failed to clone the entr source"
        exit 1
    }
else
    echo "Entr source is already here: $(pwd)/entr"
fi

# ---- Compile and install

pushd entr
git checkout 5.7

./configure || {
    echo "!Failed to configure" 
    exit 1
}
export PREFIX=$INSTALL_PREFIX
make -j install || {
    echo "!Failed to build" 
    exit 1 
}

echo "Done."
entr

