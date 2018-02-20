#!/bin/bash
# If you want to generate an image file
echo "Generating image..."
./utils/dist_partimage.sh

LOOPDEV=$(losetup -f)
if [ "$LOOPDEV" = "" ]; then
    mknod /dev/loop-control b 10 237
    mknod /dev/loop0 b 7 0
    mknod /dev/loop0 b 7 1
    mknod /dev/loop0 b 7 2
    LOOPDEV=$(losetup -f)
fi

losetup $LOOPDEV ./dist/RPi-arm64-dist.img
partprobe $LOOPDEV
mkfs.vfat -n BOOT ${LOOPDEV}p1
mkfs.btrfs -L ROOTFS ${LOOPDEV}p2

mount ${LOOPDEV}p1 ./dist/boot
mount ${LOOPDEV}p2 ./dist/rootfs

# Stage 1
echo "Running Stage 1"
./stage1/prepare_kernel.sh
./stage1/build_kernel.sh

# Stage 2
# Optional: Set MIRROR to your mirror site
MIRROR=$MIRROR
echo "Running stage 2"
./stage2/root_debootstrap.sh
./stage2/install_kernel.sh
./stage2/enable_openssh.sh

# Package firmware-brcm80211 is NON-FREE, but MAIN in archive.raspberrypi.org
# firmware-brcm80211 will be retrived from archive.raspberrypi.org
# Set FWURL to overwrite it
#FWURL=http://example.org/firmware-brcm80211_all.deb

./stage2/enable_nonfree.sh
./stage2/install_firmware_brcm.sh

# Optional
./stage2/enable_armhf.sh
#./stage2/enable_armel.sh

# Stage 3
echo "Running Stage 3"
./stage3/bootcode_install.sh
./stage3/kernel_install.sh
./stage3/create_bootconf.sh
./stage3/create_fstab.sh

# Stage 4
# Set root password and add new user
AUTOMODE=1 PASSWORD=raspberry ./stage4/passwd_root.sh
AUTOMODE=1 PASSWORD=raspberry ./stage4/adduser.sh pi

# If you want a hotspot
SSID=U.M.R-RPi3 PSK=raspberry ./stage4/setup_hostapd.sh
# If you want ethernet access
./stage4/interface_dhcp.sh
# If you are building an image
./stage4/deploy_init_resizer.sh

# Extra
./utils/install_firmware_wl.sh

echo "Done."
