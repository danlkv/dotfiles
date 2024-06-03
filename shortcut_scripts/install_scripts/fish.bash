mkdir -p ~/git-build/
cd ~/git-build
wget https://github.com/fish-shell/fish-shell/releases/download/3.7.1/fish-3.7.1.tar.xz
tar -xvf fish-3.7.1.tar.xz
cd fish-3.7.1
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local .
make -j 8; make install
export PATH=$HOME/.local/bin:$PATH
