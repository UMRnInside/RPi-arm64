#!/bin/bash

. $(dirname $0)/../global_definitions

# Environmental configs
export ARCH CROSS_COMPILE INSTALL_PATH INSTALL_MOD_PATH INSTALL_HDR_PATH
# Ready to compile
pushd $BUILD_PATH/linux

# Compile!
echo "Compiling kernel, which might take a LONG while..."
JOBCOUNT=${JOBCOUNT=$(nproc)}

# make oldconfig using default settings
yes "" | make oldconfig
make -j $JOBCOUNT

echo "Compiling modules..."
make modules
echo "Making dtbs..."
make dtbs

mkdir -p $INSTALL_PATH
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
pushd $INSTALL_PATH
rm -v *.old
cp -v vmlinuz* kernel8.img
cp -v $( find dtbs | grep -E 'bcm(.*)rpi' ) .
cp -a $( find dtbs | grep -E 'overlays$' ) .

# 2 pushd ran
popd
popd
echo "Done, kernel is ready in $INSTALL_PATH"
