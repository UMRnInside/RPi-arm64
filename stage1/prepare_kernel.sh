#!/bin/bash

. $(dirname $0)/../global_definitions

mkdir -p $BUILD_PATH

pushd $BUILD_PATH

if [ ! $SKIP_KERNELFETCH ]; then
    if [ $FETCH_METHOD == "git" ]; then
        echo "Fetching kernel using git clone, target $LINUX_BRANCH ..."
        git clone $GITCLONE_ARGS ${GIT_PROTOCOL}github.com/raspberrypi/linux -b $LINUX_BRANCH
    elif [ $FETCH_METHOD == "wget" ]; then
        echo "Fetching kernel using wget, target $LINUX_BRANCH ..."
        incomplete=1
        while [ $incomplete -ne 0 ]; 
        do
            rm linux-rpi.tar.gz
            wget -O linux-rpi.tar.gz -c https://github.com/raspberrypi/linux/archive/${LINUX_BRANCH}.tar.gz
            tar -xf linux-rpi.tar.gz
            incomplete=$?
        done
        mv linux-${LINUX_BRANCH} linux
    fi
else
    echo "Skipping kernel fetch, as SKIP_KERNELFETCH is set"
fi

popd

# Prepare for building

if [ $LINUX_BRANCH = "rpi-4.12.y" ]; then
    echo "Patching $THERMAL_PATCH_DEST"
    echo "See https://github.com/raspberrypi/linux/issues/2136 for more infomation"
    patch $THERMAL_PATCH_DEST $THERMAL_PATCH_FILE
fi

if [ ${KERNEL_USE_DEFCONFIG:=0} -eq 1 ];then
    echo "Kernel config use predefined..."
    ( cd $BUILD_PATH/linux/ &&  make bcmrpi3_defconfig )
else
    echo "Copying config..."
    cp $BCMRPI3_CONFFILE $BUILD_PATH/linux/.config
fi