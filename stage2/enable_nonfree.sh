#!/bin/bash

. $(dirname $0)/../global_definitions

echo "Modifing /etc/apt/sources.list ..."
echo "NOTE: $SUITE-backports will not be put in the file"
echo "deb $MIRROR $SUITE main non-free contrib" > $ROOT_PATH/etc/apt/sources.list

if [ ! ${SKIP_APTUPDATE=0} -eq 1 ]; then
    echo "Running apt-get update..."
    chroot $ROOT_PATH apt-get update
fi
