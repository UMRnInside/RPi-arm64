#!/bin/bash

. $(dirname $0)/../global_definitions

CONFIG=$(dirname $0)/../config

if [ ! -e $CONFIG ]; then
    echo "Copying default config..."
    CONFIG=$(dirname $0)/../rpi3_defconfig;
fi

mkdir -p $ROOT_PATH/etc/RPi-arm64

cp $CONFIG $ROOT_PATH/etc/RPi-arm64/config

COMMIT="$(git log | head -n 1 | awk '{print $2}')"
echo "We are at commit $COMMIT"

echo $COMMIT > $ROOT_PATH/etc/RPi-arm64/commit
