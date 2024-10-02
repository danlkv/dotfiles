
# if `unison` exists, return 0
# Use install path only to check the binary
path=$INSTALL_PREFIX/bin:$PATH
path=$(PATH=$path command -v unison)
test -z "$path" || {
    echo "Unison is already here: $path"
    exit 0
}

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
echo "Downloading unison source into SOURCE_DIR: $SOURCE_DIR"
echo "Prefix is INSTALL_PREFIX: $INSTALL_PREFIX"

mkdir -p $SOURCE_DIR
pushd $SOURCE_DIR

archive=https://github.com/bcpierce00/unison/releases/download/v2.53.5/unison-2.53.5-ubuntu-x86_64-static.tar.gz
wget $archive || {
    echo "!Failed to download unison archive"
    exit 1
}
mkdir unison-2.53.5
tar -xvf unison-2.53.5-ubuntu-x86_64-static.tar.gz -C unison-2.53.5/|| { echo "!Failed to extract"; exit 1; }

mkdir -p $INSTALL_PREFIX/bin
ln -s $PWD/unison-2.53.5/bin/* $INSTALL_PREFIX/bin/
popd

echo "Unison version:"
unison -version || { return 1; }
