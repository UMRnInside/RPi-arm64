#!/bin/bash

. $(dirname $0)/../global_definitions

echo "Running passwd root in $ROOT_PATH"

if [ ${AUTOMODE-0} -eq 1 ]; then
    PASSWORD=${PASSWORD-$2};
    echo "Running chpasswd...";
    echo "user: root, password: $PASSWORD"
    command="echo root:$PASSWORD | chpasswd"
    chroot $ROOT_PATH sh -c "$command"
else
    echo "Running adduser $1 in $ROOT_PATH"
    chroot $ROOT_PATH adduser $1
fi
