#!/bin/bash

. $(dirname $0)/../global_definitions

echo "Adding armel support"
chroot $ROOT_PATH dpkg --add-architecture armel
chroot $ROOT_PATH apt-get update
chroot $ROOT_PATH apt-get -y install libc6:armel
