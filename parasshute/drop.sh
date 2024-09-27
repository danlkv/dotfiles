#!/bin/bash

export SOURCE_DIR=$HOME/git-build/
export INSTALL_PREFIX=$HOME/.local/

echo "Available to install:"
find . -name drop.sh | sed 's|/drop.sh||g' | sort

# Check if argument is passed
# If not, exit
# If yes, check if the argument is a directory

if [ $# -eq 0 ]; then
    echo "Usage: $0 directory"
    exit 1
fi
$1/drop.sh
