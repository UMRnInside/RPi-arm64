#!/bin/bash

. $(dirname $0)/../global_definitions

RESIZE_TARGET=${RESIZE_TARGET-$1}

if [ ! -e $RESIZE_TARGET ]; then
    if [ ! $RESIZE_TARGET ]; then
        echo "No RESIZE_TARGET configured."
    else
        echo "$RESIZE_TARGET not found."
    fi
    echo "You should specify an exist block device or a mounted directory as RESIZE_TARGET"
    echo "e.g. FSTYPE=f2fs RESIZE_TARGET=/dev/hdd2 $0"
    echo "e.g. FSTYPE=btrfs $0 /mnt/target_root"
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
        btrfs)
            RESIZER=$(which btrfs)
            RESIZER_ARGS="filesystem resize max"
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
$RESIZER $RESIZER_ARGS $RESIZE_TARGET

