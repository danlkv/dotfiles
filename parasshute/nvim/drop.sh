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


# -- Utils

function check_command() {
    if ! command -v $1 > /dev/null; then
        echo "$1 is not installed"
        exit 1
    fi
}

# -- Install
echo "Downloading neovim source into SOURCE_DIR: $SOURCE_DIR"
echo "Prefix is INSTALL_PREFIX: $INSTALL_PREFIX"

nvim_install_from_source=false

# ---- helper functions
#
function install_from_source() {
    # Download sources and build
    # DEPEND: 
    # - curl, gettext-dev and ninja
    # Details: https://github.com/neovim/neovim/blob/stable/BUILD.md#build-prerequisites
    check_command curl
    check_command gettext
    check_command ninja

    mkdir -p $SOURCE_DIR
    if [ ! -d $SOURCE_DIR/neovim ]; then
        echo "Downloading neovim source into SOURCE_DIR: $SOURCE_DIR"
        nvim_git_repo="https://github.com/neovim/neovim.git"
        git clone --depth 1 --branch stable $nvim_git_repo $SOURCE_DIR/neovim || { exit 1; }
    fi
    pushd $SOURCE_DIR/neovim
    make CMAKE_BUILD_TYPE=Release || { echo "!Failed to build"; exit 1; }
    make CMAKE_INSTALL_PREFIX=$INSTALL_PREFIX install || { echo "!Failed to install"; exit 1; }
}

function install_from_distribution() {
    # Install from distribution
    # DEPEND: 
    # - wget and tar
    # Download binaries
    mkdir -p $SOURCE_DIR
    echo "Downloading neovim compiled binaries archive into SOURCE_DIR: $SOURCE_DIR"
    pushd $SOURCE_DIR
    # DEPEND: wget
    archive_name=nvim-linux-x86_64.tar.gz
    dirname=$(basename "$archive_name" .tar.gz)
    wget https://github.com/neovim/neovim/releases/latest/download/$archive_name || {
        echo "!Failed to download neovim"
        exit 1
    }
    tar -xvf $archive_name || { echo "!Failed to extract"; exit 1; }
    mkdir -p $INSTALL_PREFIX/bin
    unlink $INSTALL_PREFIX/bin/nvim
    ln -s $PWD/$dirname/bin/nvim $INSTALL_PREFIX/bin
    popd
    nvim --version || { return 1; }
}
#
# ----

if $nvim_install_from_source; then
    install_from_source 
else
    #
    # NOTE: will try to install from distribution,
    #   but if it fails, will fallback to source.
    #   This will leave an archive.
    #
    install_from_distribution || {
        echo "!Failed to install from binary distribution"
        echo "Try to install from source"
        install_from_source
    }
fi

export PATH=$INSTALL_PREFIX/bin:$PATH
nvim --version
