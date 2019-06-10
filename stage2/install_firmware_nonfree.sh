#!/bin/bash

. $(dirname $0)/../global_definitions

mkdir -p $BUILD_PATH

pushd $BUILD_PATH

if [ $FETCH_METHOD == "git" ]; then
    echo "Fetching firmware-nonfree using git clone ..."
    git clone $GITCLONE_ARGS ${GIT_PROTOCOL}github.com/RPi-Distro/firmware-nonfree
elif [ $FETCH_METHOD == "wget" ]; then
    echo "Fetching formware-nonfree using wget ..."
    incomplete=1
    while [ $incomplete -ne 0 ]; 
    do
        rm firmware-nonfree.tar.gz
        wget -O firmware-nonfree.tar.gz -c https://github.com/RPi-Distro/firmware-nonfree/archive/master.tar.gz
        tar -xf firmware-nonfree.tar.gz
        incomplete=$?
    done
    mv firmware-nonfree-master firmware-nonfree
fi

popd

echo "Installing firmware..."
if [ ${BRCMONLY-1} -eq 1 ]; then
    echo "Copy brcm only"
    # or it might be too large ...
    # fix Issue 15
    mkdir $ROOT_PATH/lib/firmware
    cp -a $BUILD_PATH/firmware-nonfree/brcm $ROOT_PATH/lib/firmware
else
    cp -a $BUILD_PATH/firmware-nonfree/ $ROOT_PATH/lib/firmware
fi

