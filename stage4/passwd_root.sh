#!/bin/bash

. $(dirname $0)/../global_definitions

echo "Running passwd root in $ROOT_PATH"
chroot $ROOT_PATH passwd root
