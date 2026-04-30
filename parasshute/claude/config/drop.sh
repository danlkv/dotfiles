#!/bin/bash
# -- Link Claude settings.json, if present in dotfiles

settings_src=$(realpath "$PWD/../../../.claude/settings.json")
claude_dir=$HOME/.claude
settings_dst=$claude_dir/settings.json

mkdir -p "$claude_dir"

if [ ! -f "$settings_src" ]; then
    echo "Settings source not found, skipping: $settings_src"
    exit 0
fi

if [ -e "$settings_dst" ] || [ -L "$settings_dst" ]; then
    echo "Settings destination already exists: $settings_dst. Exit."
    exit 1
fi

ln -s "$settings_src" "$settings_dst"
echo "Linked $settings_dst -> $settings_src"
