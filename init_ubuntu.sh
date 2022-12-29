#!/bin/bash
installDocker=false
installSdkman=false
installFish=false
installTMUX=false
aptUpgrade=false


read -p "Install/refresh docker? (Y/N) " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]];then
  installDocker=true
fi

read -p "Install sdkman? (Y/N) " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]];then
  installSdkman=true
fi


read -p "Install fish shell? (Y/N) " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]];then
  installFish=true
fi


read -p "Install tmux? (Y/N) " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]];then
  installTMUX=true
fi

read -p "Update/upgrade apt? (Y/N) " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]];then
  aptUpgrade=true
fi

if [ "$aptUpgrade" = true ];then
  sudo apt update
  sudo apt upgrade -y
fi

mkdir -p initBuildDir && pushd initBuildDir
rm -rf *
sudo apt-get install -y vim-gtk gcc git zip unzip curl make


if [ "$installTMUX" = true ];then 
  mkdir -p libevent
  curl -fsSL https://github.com/libevent/libevent/releases/download/release-2.1.11-stable/libevent-2.1.11-stable.tar.gz | tar -xzvf - -C libevent --strip=1 --show-stored-names
  pushd libevent
  ./configure --prefix="$HOME/.local" --enable-shared
  make && make install
  popd

  mkdir -p ncurses
  curl -fsSL https://ftp.gnu.org/gnu/ncurses/ncurses-6.2.tar.gz | tar xzvf - -C ncurses --strip=1 --show-stored-names
  pushd ncurses
  ./configure --prefix="$HOME/.local" --with-shared --enable-pc-files --with-pkg-config-libdir="$HOME/.local/lib/pkgconfig"
  make && make install
  popd

  mkdir -p tmux
  curl -fsSL https://github.com/tmux/tmux/releases/download/3.0a/tmux-3.0a.tar.gz | tar zvxf - -C tmux --strip=1 --show-stored-names
  pushd tmux
  ./configure CFLAGS="-I$HOME/.local/include -I$HOME/.local/include/ncurses" LDFLAGS="-L$HOME/.local/lib -L$HOME/.local/include/ncurses -L$HOME/.local/include" CPPFLAGS="-I$HOME/.local/include -I$HOME/.local/include/ncurses" LDFLAGS="-static -L$HOME/.local/include -L$HOME/.local/include/ncurses -L$HOME/.local/lib" 
  make
  cp tmux "$HOME/.local/bin"
  popd

  cat << 'THIS_EOF'>> ~/.bashrc
#MANPATH=$HOME/.local/share/man man tmux
export PATH=$HOME/.local/bin:$PATH
export LD_LIBRARY_PATH=$HOME/.local/lib:$LD_LIBRARY_PATH
#export MANPATH=$HOME/.local/share/man:$MANPATH
THIS_EOF
fi

if [ "$installSdkman" = true ];then 
#sdkman
  curl -s "https://get.sdkman.io" | bash
  cat << 'THIS_EOF' >> ~/.bashrc
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
THIS_EOF
fi

if [ "$installFish" = true ];then 
  #fish configuration
  sudo apt-add-repository ppa:fish-shell/release-3 -y
  sudo apt-get install -y fish
  fish -c 'curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher'
  fish -c 'fisher install reitzig/sdkman-for-fish'
  fish -c 'fisher install agalbenus/theme-cbjohnson'
  chsh -s $(which fish)
fi
if [ "$installDocker" = true ];then 
#docker
  if which docker; then
      echo "!!!Refresh docker installation!!!"
      sudo apt-get remove docker docker-engine docker.io containerd runc docker-ce docker-ce-cli containerd.io
  fi
  curl -fsSL https://get.docker.com | sh - && sudo usermod -aG docker $USER
fi

# source bash config
source ~/.bashrc
popd
