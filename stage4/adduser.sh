#!/bin/bash

. $(dirname $0)/../global_definitions

if [ ! $@ ]; then
    echo "ERROR: You should specify a username"
    echo "e.g. $0 pi"
    exit 1
fi

if [ ${AUTOMODE-0} -eq 1 ]; then
    PASSWORD=${PASSWORD-$2};
    echo "Running adduser --disabled-password --gecos \"\" $1 "
    chroot $ROOT_PATH adduser --disabled-password --gecos "" $1

    echo "Running chpasswd...";
    echo "user: $1, password: $PASSWORD"
    command="echo $1:$PASSWORD | chpasswd"
    chroot $ROOT_PATH sh -c "$command"
else
    echo "Running adduser $1 in $ROOT_PATH"
    chroot $ROOT_PATH adduser $1
fi
