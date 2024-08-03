#!/bin/bash

# DEPEND: fisher
./drop.sh fisher || exit 1
export PATH=$INSTALL_PREFIX/bin:$PATH
tide_version=$(fish -c "fisher list tide@v6")
if [ -n "$tide_version" ]; then
    echo "Tide is already installed"
    exit 0
fi
tide_cmd="fisher install IlanCosman/tide@v6"
fish -c "$tide_cmd" || exit 1
