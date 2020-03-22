#!/bin/bash

sudo dpkg --add-architecture i386sudo && sudo apt update
sudo apt install -y libstdc++5:i386 libx11-6:i386 libpam0g:i386

sudo bash -c "curl -fsSL https://starkers.keybase.pub/snx_install_linux30.sh?dl=1 | bash"
cat << THIS_EOF > ~/.snxrc
server access.axway.net
username $1
reauth yes
THIS_EOF
