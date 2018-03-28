#!/bin/bash

. $(dirname $0)/../global_definitions

echo "Cleanup ..."

chroot $ROOT_PATH rm -fv /firmware-brcm80211.deb
chroot $ROOT_PATH apt clean
chroot $ROOT_PATH ldconfig    # /opt/vc/lib/
