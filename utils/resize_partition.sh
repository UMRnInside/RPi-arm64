#!/bin/bash

. $(dirname $0)/../global_definitions

ROOTPART_ID=${ROOTPART_ID=2}
BLOCKDEV=${BLOCKDEV-$1}
DESTSIZE=${DESTSIZE-"100%"}

if [ ! -e $BLOCKDEV ]; then
    if [ ! $BLOCKDEV ]; then
        echo "No BLOCKDEV configured."
    else
        echo "$BLOCKDEV not found."
    fi
    echo "You should specify an exist block device as BLOCKDEV"
    echo "e.g. BLOCKDEV=/dev/hdd $0"
    echo "e.g. $0 /dev/hdd"
    exit 1
fi

echo "Resizing partition..."
parted -s $BLOCKDEV -- resizepart $ROOTPART_ID $DESTSIZE
