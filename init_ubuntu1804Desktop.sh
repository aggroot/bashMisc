#!/bin/bash
installDocker=false
installSdkman=false
installSNX=false
installTilda=false
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

read -p "Install snx? (Y/N) " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]];then
  installSNX=true
fi

read -p "Install fish shell? (Y/N) " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]];then
  installFish=true
fi

read -p "Install tilda terminal? (Y/N) " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]];then
  installTilda=true
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
  sudo apt-add-repository ppa:fish-shell/release-3 -y
fi

mkdir -p initBuildDir && pushd initBuildDir
rm -rf *
sudo apt-get install  vim-gtk git zip unzip curl

if [ "$installTilda" = true ];then
  
  #tilda source compiling required dependencies and other utilities
  sudo apt-get install -y dh-autoreconf autotools-dev debhelper libconfuse-dev libgtk-3-dev libvte-2.91-dev  libpcre2-dev pkg-config 
  git clone https://github.com/lanoxx/tilda.git && pushd tilda
  git checkout tags/tilda-1.5.0
  mkdir build
  cd build
  ../autogen.sh --prefix=/usr
  make --silent
  sudo make uninstall
  sudo make clean install
  popd

  #tilda default configuration
  mkdir -p ~/.config/tilda
  cat << 'THIS_EOF' > ~/.config/tilda/config_0
tilda_config_version="1.5.0"
# command=""
font="Monospace 11"
key="F1"
addtab_key="<Shift><Control>t"
fullscreen_key="F11"
toggle_transparency_key="F12"
toggle_searchbar_key="<Shift><Control>f"
closetab_key="<Shift><Control>w"
nexttab_key="<Control>Page_Down"
prevtab_key="<Control>Page_Up"
movetableft_key="<Shift><Control>Page_Up"
movetabright_key="<Shift><Control>Page_Down"
gototab_1_key="<Alt>1"
gototab_2_key="<Alt>2"
gototab_3_key="<Alt>3"
gototab_4_key="<Alt>4"
gototab_5_key="<Alt>5"
gototab_6_key="<Alt>6"
gototab_7_key="<Alt>7"
gototab_8_key="<Alt>8"
gototab_9_key="<Alt>9"
gototab_10_key="<Alt>0"
copy_key="<Shift><Control>c"
paste_key="<Shift><Control>v"
quit_key="<Shift><Control>q"
title="Tilda"
background_color="white"
# working_dir=""
web_browser="xdg-open"
increase_font_size_key="<Control>equal"
decrease_font_size_key="<Control>minus"
normalize_font_size_key="<Control>0"
# show_on_monitor=""
word_chars="-A-Za-z0-9,./?%&#:_"
lines=5000
x_pos=130
y_pos=43
tab_pos=0
expand_tabs=false
show_single_tab=false
backspace_key=0
delete_key=1
d_set_title=3
command_exit=2
command_timeout_ms=3000
scheme=3
slide_sleep_usec=20000
animation_orientation=0
timer_resolution=200
auto_hide_time=2000
on_last_terminal_exit=0
prompt_on_exit=true
palette_scheme=1
non_focus_pull_up_behaviour=0
cursor_shape=0
title_max_length=25
palette = {11822, 13364, 13878, 52428, 0, 0, 20046, 39578, 1542, 50372, 41120, 0, 13364, 25957, 42148, 30069, 20560, 31611, 1542, 38944, 39578, 54227, 55255, 53199, 21845, 22359, 21331, 61423, 10537, 10537, 35466, 58082, 13364, 64764, 59881, 20303, 29298, 40863, 53199, 44461, 32639, 43176, 13364, 58082, 58082, 61166, 61166, 60652}
scrollbar_pos=2
back_red=0
back_green=0
back_blue=0
text_red=65535
text_green=65535
text_blue=65535
cursor_red=65535
cursor_green=65535
cursor_blue=65535
width_percentage=1911260445
height_percentage=2083059137
scroll_history_infinite=false
scroll_on_output=false
notebook_border=true
scrollbar=false
grab_focus=true
above=true
notaskbar=true
blinks=true
scroll_on_key=true
bell=false
run_command=false
pinned=true
animation=false
hidden=true
set_as_desktop=false
centered_horizontally=false
centered_vertically=true
enable_transparency=true
auto_hide_on_focus_lost=true
auto_hide_on_mouse_leave=false
title_behaviour=2
inherit_working_dir=true
command_login_shell=false
start_fullscreen=false
confirm_close_tab=true
back_alpha=41942
show_title_tooltip=false
# max_width=0
# max_height=0
# image=""
# show_on_monitor_number=0
# transparency=0
# bold=false
# title_max_length_flag=false
# antialias=false
# double_buffer=false
# scroll_background=false
# use_image=false
# min_width=0
# min_height=0
THIS_EOF

fi

if [ "$installTMUX" = true ];then 
  mkdir -p libevent
  curl -fsSL https://github.com/libevent/libevent/releases/download/release-2.1.11-stable/libevent-2.1.11-stable.tar.gz | tar -xzvf - -C libevent --strip=1 --show-stored-names
  pushd libevent
  ./configure --prefix=$HOME/local --enable-shared
  make && make install
  popd

  mkdir -p ncurses
  curl -fsSL https://ftp.gnu.org/gnu/ncurses/ncurses-6.2.tar.gz | tar xzvf - -C ncurses --strip=1 --show-stored-names
  pushd ncurses
  ./configure --prefix=$HOME/local --with-shared --enable-pc-files --with-pkg-config-libdir=$HOME/local/lib/pkgconfig
  make && make install
  popd

  mkdir -p tmux
  curl -fsSL https://github.com/tmux/tmux/releases/download/3.0a/tmux-3.0a.tar.gz | tar zvxf - -C tmux --strip=1 --show-stored-names
  pushd tmux
  PKG_CONFIG_PATH=$HOME/local/lib/pkgconfig ./configure --prefix=$HOME/local
  make && make install
  popd

  cat << THIS_EOF >> ~/.bashrc
#MANPATH=$HOME/local/share/man man tmux
export PATH=$HOME/local/bin:$PATH
export LD_LIBRARY_PATH=$HOME/local/lib:$LD_LIBRARY_PATH
#export MANPATH=$HOME/local/share/man:$MANPATH
THIS_EOF
fi

if [ "$installSdkman" = true ];then 
#sdkman
  curl -s "https://get.sdkman.io" | bash
  cat << THIS_EOF >> ~/.bashrc
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
THIS_EOF
fi

if [ "$installFish" = true ];then 
  #fish configuration
  sudo apt-get install -y fish
  fish -c 'curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish'
  fish -c 'fisher add reitzig/sdkman-for-fish'
  fish -c 'fisher add agalbenus/theme-cbjohnson'
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

if [ "$installSNX" = true ];then
  sudo bash -c "${PWD}/../snxInstall.sh agalbenus access.axway.net"
fi

# source bash config
source ~/.bashrc
popd
