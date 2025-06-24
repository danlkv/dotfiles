#!/bin/bash

# if `glab` exists, return 0
# Use install path only to check the binary
path=$INSTALL_PREFIX/bin:$PATH
glab_path=$(PATH=$path command -v glab)
test -z "$glab_path" || {
    echo "GitLab CLI is already here: $glab_path"
    exit 0
}

# Check that $SOURCE_DIR and $INSTALL_PREFIX are set
if [ -z "$SOURCE_DIR" ]; then
    echo "SOURCE_DIR is not set"
    exit 1
fi

if [ -z "$INSTALL_PREFIX" ]; then
    echo "INSTALL_PREFIX is not set"
    exit 1
fi

# DEPEND:
# - wget

# -- Install
echo "Downloading GitLab CLI archive into SOURCE_DIR: $SOURCE_DIR"
echo "Prefix is INSTALL_PREFIX: $INSTALL_PREFIX"

mkdir -p $SOURCE_DIR
pushd $SOURCE_DIR

# Create a subfolder for glab to keep things organized
glab_dir="glab-1.59.2"
mkdir -p $glab_dir
pushd $glab_dir

# Download GitLab CLI from the latest release
archive_name=glab_1.59.2_linux_amd64.tar.gz
if [ ! -f $archive_name ]; then
    echo "Downloading GitLab CLI archive: $archive_name"
    wget https://gitlab.com/gitlab-org/cli/-/releases/v1.59.2/downloads/$archive_name || {
        echo "!Failed to download GitLab CLI archive"
        exit 1
    }
else
    echo "Archive already exists: $archive_name"
fi

tar -xvf $archive_name || { echo "!Failed to extract"; exit 1; }

mkdir -p $INSTALL_PREFIX/bin

# Create symlink to the glab binary
ln -sf $PWD/bin/glab $INSTALL_PREFIX/bin/glab

popd

popd

echo "GitLab CLI usage: https://gitlab.com/gitlab-org/cli/#usage"
echo "GitLab CLI version:"

glab version || { return 1; } 