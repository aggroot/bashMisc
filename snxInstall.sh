#!/bin/bash

sudo dpkg --add-architecture i386 && sudo apt update
sudo apt install -y libstdc++5:i386 libx11-6:i386 libpam0g:i386

curl -fsSL 'https://starkers.keybase.pub/snx_install_linux30.sh?dl=1' -o snxInstaller.sh
sudo chmod a+rx snxInstaller.sh
sudo ${PWD}/snxInstaller.sh
sudo bash -c "cat << THIS_EOF > ~/.snxrc
server $2
username $1
reauth yes
THIS_EOF"
