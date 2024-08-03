#!/bin/bash

# DEPEND: fish
./drop.sh fish || exit 1

# Use install path only to check the binary
export PATH=$INSTALL_PREFIX/bin:$PATH
# if `fisher` exists, return 0
fisher_version=$(fish -c "fisher --version")
if [ -n "$fisher_version" ]; then
    echo "Fisher is already installed"
    exit 0
fi
fisher_cmd="curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
fish -c "$fisher_cmd" || exit 1
fish -c "fisher update"
fish -c "fisher --version"
