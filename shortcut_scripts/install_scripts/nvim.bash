#;/bin/bash
mkdir ~/git-build
cd ~/git-build
wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
tar -xvf nvim-linux64.tar.gz
mkdir -p ~/.local/bin
ln -rs ./nvim-linux64/bin/* ~/.local/bin/
export PATH=$HOME/.local/bin:$PATH
popd
