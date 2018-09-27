#!/bin/bash
#sudo apt update
. $(dirname $0)/../global_definitions

#常用工具
chroot $ROOT_PATH apt install ssh wget htop ncdu lrzsz vim apt-transport-https -y

#xrdp
chroot $ROOT_PATH apt install xrdp -y

#安装 xfce4 language-selector-gnome
#gsettings set org.gnome.desktop.input-sources  sources "[('xkb', 'us'),('xkb','es'),('xkb','zh')]"
chroot $ROOT_PATH apt update
chroot $ROOT_PATH apt install lxde chromium fcitx-rime -y

#改变默认端口
chroot $ROOT_PATH echo "lxsession -s LXDE -e LXDE" > ~/.xsession
chroot $ROOT_PATH service xrdp restart
#sudo systemctl isolate graphical.target

#start gui on boot
chroot $ROOT_PATH systemctl set-default graphical.target
#sudo gnome-language-selector 
