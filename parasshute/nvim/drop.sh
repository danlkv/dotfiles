#!/bin/bash

# if `nvim` exists, return 0
# Use install path only to check the binary
path=$INSTALL_PREFIX/bin:$PATH
nvim_path=$(PATH=$path command -v nvim)
test -z "$nvim_path" || {
    echo "Nvim is already here: $nvim_path"
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

# check if make and cmake are installed



# -- Install
echo "Downloading neovim source into SOURCE_DIR: $SOURCE_DIR"
echo "Prefix is INSTALL_PREFIX: $INSTALL_PREFIX"

nvim_install_from_source=false

if $nvim_install_from_source; then
    # Download sources and build
    # Needs curl and ninja
    # Details: https://github.com/neovim/neovim/blob/stable/BUILD.md#build-prerequisites
    mkdir -p $SOURCE_DIR
    echo "Downloading neovim source into SOURCE_DIR: $SOURCE_DIR"
    git clone https://github.com/neovim/neovim.git $SOURCE_DIR/neovim
    pushd $SOURCE_DIR/neovim
    git checkout stable
    make CMAKE_BUILD_TYPE=Release || {
        echo "!Failed to build neovim"
        exit 1
    }
    make CMAKE_INSTALL_PREFIX=$INSTALL_PREFIX install || {
        echo "!Failed to install neovim"
        exit 1
    }
else
    # Download binaries
    mkdir -p $SOURCE_DIR
    echo "Downloading neovim compiled binaries archive into SOURCE_DIR: $SOURCE_DIR"
    pushd $SOURCE_DIR
    # DEPEND: wget
    wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz || {
        echo "!Failed to download neovim"
        exit 1
    }
    tar -xvf nvim-linux64.tar.gz || {
        echo "!Failed to extract neovim"
        exit 1
    }
    mkdir -p $INSTALL_PREFIX/bin
    ln -s $PWD/nvim-linux64/bin/* $INSTALL_PREFIX/bin
    popd
    export PATH=$INSTALL_PREFIX/bin:$PATH
    nvim --version
fi
