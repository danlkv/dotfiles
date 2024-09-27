#!/bin/bash

# DEPEND: fish-fzf
./drop.sh fish-fzf || exit 1
export PATH=$INSTALL_PREFIX/bin:$PATH

config_src=$PWD/../.config/fish/config.fish
fish_confdir=$HOME/.config/fish
config_file=$fish_confdir/config.fish

mkdir -p $fish_confdir
echo "Linking config to $config_src"

if [ -e "$config_file" ]; then
    read -p "$config_file already exists. Do you want to delete it? [y/N]: " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        rm "$config_file"
        echo "$config_file has been deleted."
    else
        echo "Operation aborted."
        exit 1
    fi
fi

ln -s $config_src $config_file
fish
echo "Config installed."
