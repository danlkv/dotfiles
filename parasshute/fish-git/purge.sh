#!/bin/bash

# -- params
fish_module="jhillyerd/plugin-git"
# --
# -- template

export PATH=$INSTALL_PREFIX/bin:$PATH
fish_git_cmd="fisher remove $fish_module"
fish -c "$fish_git_cmd" || exit 1

# DEPEND: fisher
echo "Do you want to remove the dependency: fisher [y/N]?"
read -r answer
if [ "$answer" = "y" ]; then
    echo "Removing fisher"
    ./purge.sh fisher
fi
