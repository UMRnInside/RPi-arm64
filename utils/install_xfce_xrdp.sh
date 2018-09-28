#!/bin/bash
#sudo apt update
. $(dirname $0)/../global_definitions

#常用工具
chroot $ROOT_PATH apt install ssh tofrodos wget  htop ncdu lrzsz vim apt-transport-https mousepad -y

#xrdp
chroot $ROOT_PATH apt install xrdp -y

#安装 xfce4 language-selector-gnome
#gsettings set org.gnome.desktop.input-sources  sources "[('xkb', 'us'),('xkb','es'),('xkb','zh')]"
chroot $ROOT_PATH apt update
chroot $ROOT_PATH apt install xfce4 xfce4-terminal xterm chromium -y

#改变默认端口
#sudo sed -i 's/port=3389/port=3390/g' /etc/xrdp/xrdp.ini
chroot $ROOT_PATH echo xfce4-session >~/.xsession
chroot $ROOT_PATH service xrdp restart
#sudo systemctl isolate graphical.target

#start gui on boot
chroot $ROOT_PATH systemctl set-default graphical.target
#sudo gnome-language-selector 
