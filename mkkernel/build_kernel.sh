#!/bin/bash

. $(dirname $0)/../global_definitions

mkdir -p $BUILD_PATH
mkdir -p $INSTALL_PATH

pushd $BUILD_PATH

CHECKOUT_DEST="rpi-4.12.y"
if [ ! $SKIP_KERNELFETCH ]; then
    if [ $FETCH_METHOD == "git" ]; then
        echo "Fetching kernel using git clone, target $CHECKOUT_DEST ..."
        git clone $GITCLONE_ARGS ${GIT_PROTOCOL}github.com/raspberrypi/linux -b $CHECKOUT_DEST
    elif [ $FETCH_METHOD == "wget" ]; then
        echo "Fetching kernel using wget, target $CHECKOUT_DEST ..."
        wget -c https://github.com/raspberrypi/linux/archive/${CHECKOUT_DEST}.zip
        unzip $CHECKOUT_DEST.zip
        mv linux-${CHECKOUT_DEST} linux
    fi
else
    echo "Skipping kernel fetch, as SKIP_KERNELFETCH is set"
fi

# Prepare for building

echo "Patching $THERMAL_PATCH_DEST"
echo "See https://github.com/raspberrypi/linux/issues/2136 for more infomation"
patch $THERMAL_PATCH_DEST $THERMAL_PATCH_FILE

echo "Copying config..."
cp $BCMRPI3_CONFFILE $BUILD_PATH/linux/.config

# Environmental configs
export ARCH CROSS_COMPILE INSTALL_PATH INSTALL_MOD_PATH INSTALL_HDR_PATH
# Ready to compile
pushd linux

# Compile!
echo "Compiling kernel, which might take a LONG while..."
JOBCOUNT=${JOBCOUNT=$(nproc)}
make -j $JOBCOUNT

echo "Compiling modules..."
make modules
echo "Making dtbs..."
make dtbs

echo "Exporting to $INSTALL_PATH..."
make install
make modules_install
make dtbs_install
make headers_install

if [ ! -e $INSTALL_HDR_PATH ]; then
    echo "headers_install seems not working, manually copying files..."
    mkdir -p $INSTALL_HDR_PATH
    cp -a usr/include $INSTALL_HDR_PATH
fi

# After-compilation mods
popd
pushd $INSTALL_PATH
rm -v *.old
cp -v vmlinuz* kernel8.img
cp -v $( find dtbs | grep -E 'bcm(.*)rpi' ) .
cp -a $( find dtbs | grep -E 'overlays$' ) .
popd

echo "Done, kernel is ready in $INSTALL_PATH"
