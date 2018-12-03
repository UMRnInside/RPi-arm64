#!/bin/bash
# If you want to generate an image file
echo "Detecting config file..."

DEFCONF=rpi3_defconfig
if [ -e "config" ]; then
    echo "Using user-defined config..."
else
    echo "Copying $DEFCONF to config..."
    cp $DEFCONF config
fi

# Read config file
# Comments and empty lines should be removed

eval "export "$(cat config | grep . | grep -v -E "^ " | sed "/^#/d" )

if [ $GENERATE_IMAGE -eq 1 ]; then
    echo "Generating image..."
    ./utils/dist_partimage.sh

    LOOPDEV=$(losetup -f)
    if [ "$LOOPDEV" = "" ]; then
        mknod /dev/loop-control b 10 237
        for ((i=0;i<8;i++)) do
            mknod /dev/loop$i b 7 $i
        done
        LOOPDEV=$(losetup -f)
    fi

    losetup $LOOPDEV $IMGFILE
    partprobe $LOOPDEV
    mkfs.vfat -n BOOT ${LOOPDEV}p1
    if [ "$FSTYPE" = "f2fs" ]; then
        mkfs.$FSTYPE -l ROOTFS ${LOOPDEV}p2
    elif [ "$FSTYPE" = "btrfs" ]; then
        # Fix "No space left" error
        mkfs.$FSTYPE --nodesize 4096 -L ROOTFS ${LOOPDEV}p2
    else
        mkfs.$FSTYPE -L ROOTFS ${LOOPDEV}p2
    fi

    mount ${LOOPDEV}p1 ./dist/boot
    mount ${LOOPDEV}p2 ./dist/rootfs
fi

if [ "$PRERUN_SCRIPTS" != "" ]; then
    for i in "$PRERUN_SCRIPTS"; do
        $i
    done
fi

# Stage 1
if [ $SKIP_STAGE1 -eq 1 ]; then
    echo "Skipping stage 1..."
else
    echo "Running Stage 1"
    ./stage1/prepare_kernel.sh
    ./stage1/build_kernel.sh
fi

# Stage 2
# Optional: Set MIRROR to your mirror site
echo "Running stage 2"
./stage2/root_debootstrap.sh
./stage2/install_kernel.sh

if [ $CONFIG_OPENSSH_SERVER -eq 1 ]; then
    ./stage2/enable_openssh.sh
fi

./stage2/enable_nonfree.sh
./stage2/install_firmware_"$FIRMWARE_SOURCE".sh

# Optional
if [ $CONFIG_ARMHF_SUPPORT -eq 1 ]; then
    ./stage2/enable_armhf.sh
fi
if [ $CONFIG_ARMEL_SUPPORT -eq 1 ]; then
    ./stage2/enable_armel.sh
fi

# Stage 3
echo "Running Stage 3"

./stage3/bootcode_install.sh
./stage3/kernel_install.sh

if [ $USE_PARTUUID -eq 1 ] && [ $GENERATE_IMAGE -eq 1 ]; then
    echo "Syncing..."
    sync

    IMGID="$(dd if=${IMGFILE} skip=440 bs=1 count=4 2>/dev/null | xxd -e | cut -f 2 -d' ')"
    echo "got common PARTUUID: $IMGID"

    BOOT_PARTUUID="${IMGID}-01"
    ROOT_PARTUUID="${IMGID}-02"

    ROOT_PART="PARTUUID=$ROOT_PARTUUID" ./stage3/create_bootconf.sh
    ROOT_PART="PARTUUID=$ROOT_PARTUUID" BOOT_PART="PARTUUID=$BOOT_PARTUUID" ./stage3/create_fstab.sh
else
    ./stage3/create_bootconf.sh
    ./stage3/create_fstab.sh
fi

# Stage 4
# Set root password and add new user
AUTOMODE=1 PASSWORD=$PASSWORD_ROOT ./stage4/passwd_root.sh
AUTOMODE=1 PASSWORD=$PASSWORD_USER ./stage4/adduser.sh $NEW_USER

# If you want a hotspot
if [ ${CONFIG_HOTSPOT} -eq 1 ] ;then
    ./stage4/setup_hostapd.sh
else
    ./stage4/setup_wifi.sh
fi

# If you want ethernet access
./stage4/interface_dhcp.sh

# If you are building an image
BOOT_PART=${BOOT_PART-"/dev/mmcblk0p1"} ./stage4/deploy_init_resizer.sh

# Extra
if [ $INSTALL_EXTRA_WIRELESS_FIRMWARE -eq 1 ]; then
    ./utils/install_firmware_wl.sh
fi
if [ ${INSTALL_EXTRA_RASPBIAN_SERVICES:=1} -eq 1 ]; then
    ./utils/install_raspbian_services.sh
fi
if [ ${INSTALL_XFCE_XRDP:=0} -eq 1 ]; then
    ./utils/install_xfce_xrdp.sh
fi
if [ ${INSTALL_LXDE:=0} -eq 1 ]; then
    ./utils/install_lxde.sh
fi
if [ ${INSTALL_LXDE_XRDP:=0} -eq 1 ]; then
    ./utils/install_lxde_xrdp.sh
fi

if [ ${INSTALL_I3WM:=0} -eq 1 ]; then
    ./utils/install_i3wm.sh
fi
if [ ${INSTALL_CHINESE:=0} -eq 1 ]; then
    ./utils/install_chinese.sh
fi
if [ ${INSTALL_RASPI:=0} -eq 1 ]; then
    ./utils/install_raspi.sh
fi
if [ "$POSTRUN_SCRIPTS" != "" ]; then
    for i in "$POSTRUN_SCRIPTS"; do
        $i
    done
fi

# Copy build info
./utils/copy_build_info.sh

# Cleanup
./utils/cleanup.sh

if [ $GENERATE_IMAGE -eq 1 ]; then
    echo "Unmounting..."
    umount dist/boot
    umount dist/rootfs

    echo "Detaching $LOOPDEV"
    losetup -d $LOOPDEV
fi

echo "Done."
