#!/bin/bash

. $(dirname $0)/../global_definitions

echo "Copying dtbs..."
cp -a $KERNEL_DIST_PATH/*.dtb $BOOT_PATH/
cp -a $KERNEL_DIST_PATH/overlays $BOOT_PATH/

echo "Copying kernel8.img..."
cp -v $KERNEL_DIST_PATH/kernel8.img $BOOT_PATH/

echo "Done."
