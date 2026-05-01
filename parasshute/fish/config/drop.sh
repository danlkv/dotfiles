#!/bin/bash

# DEPEND: fish-fzf
./drop.sh fish-fzf || exit 1
export PATH=$INSTALL_PREFIX/bin:$PATH

config_src=$PWD/../.config/fish/config.fish
fish_confdir=$HOME/.config/fish
config_file=$fish_confdir/config.fish

mkdir -p $fish_confdir
echo "Linking config to $config_src"

# gentle_link: ask before linking and skip if linked already.
gentle_link() {
    local src=$1 dst=$2
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        echo "Already linked: $dst -> $src"
        return 0
    elif [ -e "$dst" ] || [ -L "$dst" ]; then
        read -p "$dst already exists. Replace with symlink? [y/N]: " answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            rm "$dst"
        else
            echo "Skipping $dst."
            return 1
        fi
    fi
    ln -s "$src" "$dst"
    echo "Linked $dst -> $src"
}

gentle_link "$config_src" "$config_file" || exit 1

# Link individual conf.d snippets (don't symlink the directory — plugins write into it)
confd_src_dir=$PWD/../.config/fish/conf.d
confd_dst_dir=$fish_confdir/conf.d
mkdir -p $confd_dst_dir
for src in $confd_src_dir/*.fish; do
    [ -e "$src" ] || continue
    gentle_link "$src" "$confd_dst_dir/$(basename "$src")"
done

