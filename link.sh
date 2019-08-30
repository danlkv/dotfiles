#!/bin/bash

DOTFILES_DIR=$HOME/dotfiles

ln -sf $(find $DOTFILES_DIR -mindepth 1 -maxdepth 1 | grep --invert-match --extended-regexp "^$DOTFILES_DIR/(.git)|(link.sh)$") $HOME
