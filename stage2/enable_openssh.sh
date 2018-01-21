#!/bin/bash

. $(dirname $0)/../global_definitions

echo "Installing Openssh server..."
chroot $ROOT_PATH apt-get -y install openssh-server

