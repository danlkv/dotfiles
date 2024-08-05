#!/bin/bash
# Template to create install scripts for fish plugins

# -- params
fish_module="user/module_name"
fish_module_name="module name"
# --

# DEPEND: fisher
./drop.sh fisher || exit 1
export PATH=$INSTALL_PREFIX/bin:$PATH
plugin_git_=$(fish -c "fisher list $fish_module")
if [ -n "$plugin_git_" ]; then
    echo "$fish_module_name is already installed"
    exit 0
fi
fish_git_cmd="fisher install $fish_module"
fish -c "$fish_git_cmd" || exit 1
