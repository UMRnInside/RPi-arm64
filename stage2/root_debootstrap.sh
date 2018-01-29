#!/bin/bash

. $(dirname $0)/../global_definitions
DEB_INCLUDE_INITIAL="busybox,wpasupplicant,vim"
DEB_INCLUDE=${DEB_INCLUDE_INITIAL},${DEB_INCLUDE};

if [ ! -e $DEBOOTSTRAP_BIN ]; then
    echo "ERROR: No debootstrap found!";
    exit 1;
fi

# Make dir, stop debootstrap from failing 
mkdir -p $ROOT_PATH

# If we are on arm64 or have qemu-aarch64-static
DEB_NATIVE=0
DEB_QEMU=0
if [ $(uname -m) = "aarch64" ]; then
    echo "It seems that you can run arm64 binaries natively."
    DEB_NATIVE=1;
elif [ -e $(which qemu-aarch64-static) ]; then
    DEB_QEMU=1;
    qemu_path=$(which qemu-aarch64-static)
    echo "Detected available qemu at $qemu_path"
    mkdir -p ${ROOT_PATH}/$(dirname $qemu_path)
    cp -v $qemu_path ${ROOT_PATH}/${qemu_path}
fi

echo "Running $DEBOOTSTRAP_BIN..."
$DEBOOTSTRAP_BIN $DEB_ARGS --arch $DEB_ARCH --include $DEB_INCLUDE $SUITE $ROOT_PATH $MIRROR

if [ ! ${SKIP_APTUPDATE-0} -eq 1 ]; then
    echo "Running apt-get update"
    chroot $ROOT_PATH apt-get update
fi
