#!/bin/bash
# Template to create remove scripts for fish plugins

# -- params
fish_module="user/module_name"
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
