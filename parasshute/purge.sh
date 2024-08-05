#!/bin/bash

export SOURCE_DIR=$HOME/git-build/
export INSTALL_PREFIX=$HOME/.local/

# Check if argument is passed
# If not, exit
# If yes, check if the argument is a directory

if [ $# -eq 0 ]; then
    echo "Usage: $0 directory"
    exit 1
fi
$1/purge.sh
