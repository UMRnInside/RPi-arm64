#!/bin/bash

. $(dirname $0)/../global_definitions

if [ ! $ROOT_PATH ]; then
    echo "WARNING: ROOT_PATH is not set!";
fi

echo "${BOOT_PART-/dev/mmcblk0p1} /boot   vfat    noatime  0   0" > $ROOT_PATH/etc/fstab

case $FSTYPE in
    ext4|f2fs)
        echo "${ROOT_PART-/dev/mmcblk0p2} /   $FSTYPE    discard,noatime  0   1" >> $ROOT_PATH/etc/fstab
        ;;
    ext3|ext2)
        echo "Rootfs using $FSTYPE, but ext4/f2fs should be better"
        echo "${ROOT_PART-/dev/mmcblk0p2} /   $FSTYPE    discard,noatime  0   1" >> $ROOT_PATH/etc/fstab
        ;;
    btrfs) 
        echo "${ROOT_PART-/dev/mmcblk0p2} /   $FSTYPE    ssd,discard,noatime  0   1" >> $ROOT_PATH/etc/fstab
        ;;
    *)
        echo "Rootfs using $FSTYPE, make sure it is a valid value."
        echo "${ROOT_PART-/dev/mmcblk0p2} /   $FSTYPE    noatime  0   1" >> $ROOT_PATH/etc/fstab
        ;;
esac

echo "Done."
