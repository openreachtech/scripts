#!/bin/bash  -i

set -e

## update & install nginx/certbot
echo dependencies update and installing...
apt update
apt install vim build-essential jq -y

## node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
. ~/.bashrc
. ~/.nvm/nvm.sh
nvm install v14.17.3

## vim
echo vim installing...
git clone https://github.com/EG-easy/dotfiles.git
cd dotfiles
make deploy

### golang
echo golang installing...
cd ~
wget https://dl.google.com/go/go1.17.2.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.17.2.linux-amd64.tar.gz
mkdir go
echo '#golang' >> ~/.bashrc
echo 'export PATH="$PATH:/usr/local/go/bin"' >> ~/.bashrc
echo 'export GOPATH="$HOME/go"' >> ~/.bashrc
echo 'export PATH="$PATH:$GOPATH/bin"' >> ~/.bashrc
echo 'export GOBIN=$GOPATH/bin' >> ~/.bashrc
echo 'export GO111MODULE=on' >> ~/.bashrc

. ~/.bashrc

### nibirud
echo nibirud installing...
git clone https://github.com/cosmos-gaminghub/nibiru
cd nibiru
git checkout -b neuron-1 tags/neuron-1
make install

### service
tee /etc/systemd/system/nibirud.service > /dev/null <<EOF
[Unit]
Description=Nibirud Full Node
After=network-online.target
[Service]
User=root
ExecStart=/root/go/bin/nibirud start
Restart=always
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable nibirud
