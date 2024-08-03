#!/bin/bash

if [ -z "$SOURCE_DIR" ]; then
    echo "SOURCE_DIR is not set"
    exit 1
fi
pushd $SOURCE_DIR/fish-shell
echo "Uninstalling fish shell"
xargs rm < install_manifest.txt
echo "Cleaning repository"
git clean -fxd
# ask to clean sources
echo "Do you want to remove the source directory $PWD? [y/N]"
read -r answer
if [ "$answer" = "y" ]; then
    popd
    echo "Removing source directory"
    rm -rf $SOURCE_DIR/fish-shell
else
    popd
fi
