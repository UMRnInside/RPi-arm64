#!/bin/bash

. $(dirname $0)/../global_definitions

mkdir -p $BUILD_PATH

pushd $BUILD_PATH

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

popd

# Prepare for building

echo "Patching $THERMAL_PATCH_DEST"
echo "See https://github.com/raspberrypi/linux/issues/2136 for more infomation"
patch $THERMAL_PATCH_DEST $THERMAL_PATCH_FILE

echo "Copying config..."
cp $BCMRPI3_CONFFILE $BUILD_PATH/linux/.config
