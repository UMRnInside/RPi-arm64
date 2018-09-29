#!/bin/bash
#sudo apt update
. $(dirname $0)/../global_definitions

chroot $ROOT_PATH apt install curl gnupg -y
curl -fsSL http://mirrors.ustc.edu.cn/archive.raspberrypi.org/debian/raspberrypi.gpg.key | chroot $ROOT_PATH apt-key add -
curl -fsSL http://mirrors.aliyun.com/raspbian/raspbian.public.key | chroot $ROOT_PATH apt-key add -
#sudo cp ~/sh/raspberry/sources.list /etc/apt/
echo "deb http://mirrors.aliyun.com/raspbian/raspbian stretch main contrib non-free rpi" > $ROOT_PATH/etc/apt/sources.list.d/raspbian.list
echo "deb http://mirrors.ustc.edu.cn/archive.raspberrypi.org/debian/ stretch main ui" > $ROOT_PATH/etc/apt/sources.list.d/raspi.list 
chroot $ROOT_PATH apt update
chroot $ROOT_PATH apt install rpi-chromium-mods raspi-config -y
rm -rf $ROOT_PATH/etc/apt/sources.list.d/raspbian.list $ROOT_PATH/etc/apt/sources.list.d/raspi.list
chroot $ROOT_PATH apt update
