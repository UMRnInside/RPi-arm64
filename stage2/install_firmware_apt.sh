#!/bin/bash

. $(dirname $0)/../global_definitions

echo "Installing firmwares..."
firmwares="firmware-brcm80211 "
chroot $ROOT_PATH apt-get install -y ${firmwares}${FW_EXTRA}
