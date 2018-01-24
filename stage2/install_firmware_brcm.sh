#!/bin/bash

. $(dirname $0)/../global_definitions

FWURL="https://archive.raspberrypi.org/debian/pool/main/f/firmware-nonfree/firmware-brcm80211_20161130-3+rpi2_all.deb"
fileName=firmware-brcm80211.deb
echo "Retriving firmware..."

wget -c -O $ROOT_PATH/$fileName $FWURL
echo "Installing firmwares..."
#firmwares="firmware-brcm80211 "

chroot $ROOT_PATH dpkg -i /$fileName
