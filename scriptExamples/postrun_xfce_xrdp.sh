#!/bin/bash
#sudo apt update

#常用工具
sudo apt install ssh tofrodos wget  htop ncdu lrzsz vim apt-transport-https mousepad -y

#xrdp
sudo apt install xrdp -y

#安装 xfce4 language-selector-gnome
#gsettings set org.gnome.desktop.input-sources  sources "[('xkb', 'us'),('xkb','es'),('xkb','zh')]"
sudo apt update
sudo apt install xfce4 xfce4-terminal xterm chromium -y

#改变默认端口
#sudo sed -i 's/port=3389/port=3390/g' /etc/xrdp/xrdp.ini
sudo echo xfce4-session >~/.xsession
sudo service xrdp restart
#sudo systemctl isolate graphical.target

#start gui on boot
sudo systemctl set-default graphical.target
#sudo gnome-language-selector 
