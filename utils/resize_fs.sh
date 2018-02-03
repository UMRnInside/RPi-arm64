#!/bin/bash

. $(dirname $0)/../global_definitions

BLOCKDEV=${BLOCKDEV-$1}

if [ ! -e $BLOCKDEV ]; then
    if [ ! $BLOCKDEV ]; then
        echo "No BLOCKDEV configured."
    else
        echo "$BLOCKDEV not found."
    fi
    echo "You should specify an exist block device as BLOCKDEV"
    echo "e.g. BLOCKDEV=/dev/hdd2 $0"
    echo "e.g. $0 /dev/hdd2"
    exit 1
fi

if [ ! $RESIZER ]; then
    case $FSTYPE in
        f2fs)
            RESIZER=$(which resize.f2fs)
            ;;
        ext2|ext3|ext4)
            RESIZER=$(which resize2fs)
            ;;
        *)
            RESIZER=$(which resize.$FSTYPE)
            echo "FSTYPE is $FSTYPE, RESIZER could be $RESIZER"
            ;;
    esac
    if [ ! -e $RESIZER ]; then
        echo "Filesystem resizer for $FSTYPE not found!"
        exit 1
    fi
fi


echo "Resizing filesystem..."
$RESIZER $BLOCKDEV

