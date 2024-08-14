#!/bin/bash

# if `brew` exists, return 0
# Use install path only to check the binary
path=$INSTALL_PREFIX/bin:$PATH
brew_path=$(PATH=$path command -v brew)
test -z "$brew_path" || {
    echo "Homebrew is already here: $brew_path"
    exit 0
}

# DEPEND:
# - curl
# - tar
# - git

homebrew_prefix="$HOME/.local/linuxbrew"
# Create a directory for linuxbrew
mkdir -p $homebrew_prefix
cd $homebrew_prefix
curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip-components 1 -C $homebrew_prefix
cmd="$homebrew_prefix/bin/brew shellenv"
mkdir -p $INSTALL_PREFIX/bin
ln -sf $homebrew_prefix/bin/brew $INSTALL_PREFIX/bin/brew
echo "!Environment configuration for Homebrew:"
echo $cmd
eval "$($cmd)"
echo "Homebrew is installed at $homebrew_prefix"
brew update
brew --version

