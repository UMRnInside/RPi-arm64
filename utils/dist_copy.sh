#!/bin/bash

. $(dirname $0)/../global_definitions

function rcopy()
{
    if [ -e $(which pv) ]; then
        tar -p -c -C $1 . | pv -rbt | tar -p -x -C $2
    else
        tar -p -c -C $1 . | tar -p -x -C $2
    fi
}

if [ $BOOT_PATH ] && [ $BOOT_DEST ]; then
    echo "Copying boot from $BOOT_PATH to $BOOT_DEST"
    rcopy $BOOT_PATH $BOOT_DEST
fi

if [ $ROOT_PATH ] && [ $ROOT_DEST ]; then
    echo "Copying rootfs from $ROOT_PATH to $ROOT_DEST"
    rcopy $ROOT_PATH $ROOT_DEST
fi
