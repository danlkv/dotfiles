mkdir -p ~/git-build
cd ~/git-build
wget https://nodejs.org/dist/v18.13.0/node-v18.13.0-linux-x64.tar.xz
tar -xvf node-v18.13.0-linux-x64.tar.xz
cd ~/git-build/node-v18.13.0-linux-x64
ln -srf lib/* ~/.local/lib/
tar -xvf 
cp bin/* ~/.local/bin/
ln -srf lib/* ~/.local/lib/
