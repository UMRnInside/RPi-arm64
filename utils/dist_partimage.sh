#!/bin/bash

. $(dirname $0)/../global_definitions

IMGFILE=${IMGFILE="$DIST_PATH/RPi-arm64-dist.img"}
IMGSIZE_MB=${IMGSIZE_MB=1024}
BOOT_SIZE=${BOOT_SIZE="120MiB"}

if [ ! -e $IMGFILE ]; then
    dd if=/dev/zero of=$IMGFILE bs=1M count=$IMGSIZE_MB
fi

parted -s $IMGFILE -- mklabel msdos
parted -s $IMGFILE -- mkpart primary fat32 4KiB $BOOT_SIZE
parted -s $IMGFILE -- mkpart primary ext2 $BOOT_SIZE 100%

parted -s $IMGFILE -- toggle 1 boot

echo "Image parted."

