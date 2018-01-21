#!/bin/bash

. $(dirname $0)/../global_definitions

if [ ! $@ ]; then
    echo "ERROR: You should specify a username"
    echo "e.g. $0 pi"
    exit 1
fi
echo "Running adduser $@ in $ROOT_PATH"
chroot $ROOT_PATH adduser $@
