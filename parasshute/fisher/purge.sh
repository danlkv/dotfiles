#!/bin/bash

# -- params
fish_module="jorgebucaran/fisher"
# --
# -- template

export PATH=$INSTALL_PREFIX/bin:$PATH
fish_git_cmd="fisher remove $fish_module"
fish -c "$fish_git_cmd" || exit 1

# DEPEND: fish
echo "Do you want to remove the dependency: fish [y/N]?"
read -r answer
if [ "$answer" = "y" ]; then
    echo "Removing fish shell"
    ./purge.sh fish
fi
