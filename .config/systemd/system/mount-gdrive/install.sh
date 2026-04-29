#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"

sudo ln -sfn "$DIR/mount-gdrive.sh" /usr/local/bin/mount-gdrive
sudo systemctl link "$DIR/mount-gdrive.service"
sudo systemctl enable mount-gdrive.service
sudo systemctl start mount-gdrive.service
sudo systemctl status mount-gdrive.service
