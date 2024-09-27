#!/bin/bash

# DEPEND: fisher
./drop.sh fisher || exit 1
export PATH=$INSTALL_PREFIX/bin:$PATH
version=$(fish -c "fisher list fzf")
if [ -n "$version" ]; then
    echo "FZF is already installed"
    exit 0
fi
cmd="fisher install patrickf1/fzf.fish"
fish -c "$cmd" || exit 1
