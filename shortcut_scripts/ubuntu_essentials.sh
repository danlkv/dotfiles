#!/bin/bash

sudo apt update
sudo apt install -y neovim tmux tree unzip
sudo apt install -y python3 python3-pip python3-numpy python3-matplotlib python3-scipy
sudo ln -srf $(which python3) /usr/bin/python
sudo ln -srf $(which pip3) /usr/bin/pip

sudo pip install jupyter pytest neovim
