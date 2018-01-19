#!/bin/bash

. $(dirname $0)/../global_definitions

echo "Installing modules..."
cp -a $KERNEL_DIST_PATH/lib/modules $ROOT_PATH/lib/
echo "Installing build-in firmware..."
cp -a $KERNEL_DIST_PATH/lib/firmware $ROOT_PATH/lib/

if [ ${INSTALL_HEADERS=1} -eq 1 ]; then
    echo "Installing headers..."
    cp -a $KERNEL_DIST_PATH/usr/include $ROOT_PATH/usr/
fi
