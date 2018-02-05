#!/bin/bash

. $(dirname $0)/../global_definitions

FIRMWARE="firmware-atheros firmware-realtek "

echo "Installing firmwares..."
echo "Attempt to install the following firmwares:"
echo ${FIRMWARE}${FIRMWARE_EXTRA}

sleep 3

chroot $ROOT_PATH apt-get -y install ${FIRMWARE}${FIRMWARE_EXTRA}

