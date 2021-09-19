#!/bin/bash
set -eu

## update & install nginx/certbot
echo dependencies update and installing...
apt update
apt install vim build-essential jq nginx certbot python3-certbot-nginx -y

## node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bashrc
nvm install v14.17.3

## vim
echo vim installing...
git clone https://github.com/EG-easy/dotfiles.git
cd dotfiles
make deploy
