#!/bin/bash

. global_definitions
DEB_INCLUDE_INITIAL="busybox"
if [ ! $DEB_INCLUDE ]; then
    DEB_INCLUDE=${DEB_IINCLUDE_INITIAL},${DEB_INCLUDE_EXTRA};
fi

if [ $ARMHF_SUPPORT -eq 1 ]; then
    DEB_INCLUDE=${DEB_INCLUDE},${LIBC_ARMHF}
fi

if [ $ARMEL_SUPPORT -eq 1 ]; then
    DEB_INCLUDE=${DEB_INCLUDE},${LIBC_ARMEL}
fi


extraargs=""
if [ $DEB_VERBOSE ]; then
    extraargs="--verbose";
fi

# Make dir, stop debootstrap from failing 
mkdir -p $ROOT_PATH

# If we are on arm64 or have qemu-aarch64-static
DEB_NATIVE=0
DEB_QEMU=0
if [ $(uname -m) = "aarch64" ]; then
    DEB_NATIVE=1;
elif [ -e $(which qemu-aarch64-static) ]; then
    DEB_QEMU=1
    qemu_path=$(which qemu-aarch64-static)
    echo "Detected available qemu at $qemu_path"
    mkdir -p ${ROOT_PATH}/$(dirname $qemu_path)
    cp -v $qemu_path ${ROOT_PATH}/${qemu_path}
fi

echo "Running debootstrap..."
$DEBOOTSTRAP_BIN $extraargs --arch $DEB_ARCH --include $DEB_INCLUDE $SUITE $ROOT_PATH $MIRROR

echo "Running post-debootstrap tasks..."

if [ $ARMHF_SUPPORT ]; then
    echo "Adding armhf support"
    chroot $ROOT_PATH dpkg --add-architecure armhf
    chroot $ROOT_PATH apt-get update
    chroot $ROOT_PATH apt-get -y install libc6:armhf
fi

if [ $ARMEL_SUPPORT ]; then
    echo "Adding armel support"
    chroot $ROOT_PATH dpkg --add-architecure armel
    chroot $ROOT_PATH apt-get update
    chroot $ROOT_PATH apt-get -y install libc6:armel
fi

if [ ! $SKIP_SOURCES_MOD ]; then
    echo "Modifing /etc/apt/sources.list ..."
    echo "NOTE: $SUITE-backports will not be put in the file"
    echo "deb $MIRROR $SUITE main non-free contrib" > $ROOT_PATH/etc/apt/sources.list
fi

if [ ! $SKIP_SOURCEUPDATE ]; then
    echo "Running apt-get update..."
    chroot $ROOT_PATH apt-get update
fi

if [ ! $SKIP_FWINST ]; then
    echo "Installing firmwares..."
    firmwares="firmware-brcm80211 firmware-atheros firmware-atheros firmware-iwlwifi firmware-realtek"
    chroot $ROOT_PATH apt install -y $firmwares 
fi

if [ $DEB_QEMU -eq 1 ]; then
    rm -v ${ROOT_PATH}/${qemu_path}
fi
