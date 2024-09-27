#!/bin/bash

# DEPEND: fisher
./drop.sh fisher || exit 1
export PATH=$INSTALL_PREFIX/bin:$PATH
version=$(fish -c "fisher list fzf")
if [ -n "$version" ]; then
    echo "FZF is already installed"
    exit 0
fi

# -- Install fzf
if [ -z "$SOURCE_DIR" ]; then
    echo "SOURCE_DIR is not set"
    exit 1
fi

if [ -z "$INSTALL_PREFIX" ]; then
    echo "INSTALL_PREFIX is not set"
    exit 1
fi
echo "Downloading neovim source into SOURCE_DIR: $SOURCE_DIR"
echo "Prefix is INSTALL_PREFIX: $INSTALL_PREFIX"


git clone --depth 1 https://github.com/junegunn/fzf.git $SOURCE_DIR/fzf
pushd $SOURCE_DIR/fzf
./install --bin
ln -s $SOURCE_DIR/fzf/bin/fzf $INSTALL_PREFIX/bin
fzf --version || { return 1; }

# -- Install fish plugin

cmd="fisher install patrickf1/fzf.fish"
fish -c "$cmd" || exit 1
fish -c "set -Ux FZF_DEFAULT_OPTS --height=30%" || exit 1
