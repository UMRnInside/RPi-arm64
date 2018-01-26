#!/bin/bash

. $(dirname $0)/../global_definitions

echo "Mounting sysfs, proc..."
mount -t sysfs sysfs $ROOT_PATH/sys
mount -t proc proc $ROOT_PATH/proc

echo "Making dev..."
mount -t tmpfs -o size=32M tmpfs $ROOT_PATH/dev
chroot $ROOT_PATH busybox mdev -s

echo "Running chroot with mounted sysfs, proc and mdev..."
chroot $ROOT_PATH

echo "Unmounting..."
umount $ROOT_PATH/sys
umount $ROOT_PATH/proc
umount $ROOT_PATH/dev
