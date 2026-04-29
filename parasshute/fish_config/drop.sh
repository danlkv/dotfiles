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
echo "Config installed."

# Link individual conf.d snippets (don't symlink the directory — plugins write into it)
confd_src_dir=$PWD/../.config/fish/conf.d
confd_dst_dir=$fish_confdir/conf.d
mkdir -p $confd_dst_dir
for src in $confd_src_dir/*.fish; do
    [ -e "$src" ] || continue
    dst=$confd_dst_dir/$(basename "$src")
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        read -p "$dst already exists. Replace with symlink? [y/N]: " answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            rm "$dst"
        else
            echo "Skipping $dst."
            continue
        fi
    fi
    ln -s "$src" "$dst"
    echo "Linked $dst -> $src"
done

