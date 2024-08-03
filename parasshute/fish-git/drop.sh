#!/bin/bash

# DEPEND: fisher
./drop.sh fisher || exit 1
export PATH=$INSTALL_PREFIX/bin:$PATH
plugin_git_=$(fish -c "fisher list jhillyerd/plugin-git")
if [ -n "$plugin_git_" ]; then
    echo "Fish git plugin is already installed"
    exit 0
fi
fish_git_cmd="fisher install jhillyerd/plugin-git"
fish -c "$fish_git_cmd" || exit 1
