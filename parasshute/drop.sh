#!/bin/bash

export INSTALL_PREFIX=${INSTALL_PREFIX:-$HOME/.local/}
export SOURCE_DIR=${SOURCE_DIR:-$INSTALL_PREFIX/sources/}

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
