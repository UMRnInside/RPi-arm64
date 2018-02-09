#!/bin/bash

. $(dirname $0)/../global_definitions

pushd $BUILD_PATH

case $FETCH_METHOD in
    "git")
        echo "Fetching bootcode using git..."
        git clone ${GIT_PROTOCOL}github.com/Hexxeh/rpi-firmware -b ${BRANCH=master}
        ;;
    "wget")
        echo "Fetching bootcode using wget..."
        wget -c -O rpi-firmware-archive.zip https://github.com/Hexxeh/rpi-firmware/archive/${BRANCH=master}.zip

        if [ -e rpi-firmware ]; then
            echo "Removing old unzipped files"
            rm -r rpi-firmware/
        fi

        unzip rpi-firmware-archive.zip -x "*modules/*"
        mv rpi-firmware-${BRANCH} rpi-firmware
        ;;
    *)
        echo "Skipping fetch, as FETCH_METHOD is neither wget nor git."
        ;;
esac

popd

for fw in $FW_BOOT; do
    cp $BUILD_PATH/rpi-firmware/$fw $BOOT_PATH
done

if [ ${INSTALL_VC-1} -eq 1 ]; then
    echo "Installing VideoCore userland(/opt/vc)..."
    echo "Using "${FPTYPE=hardfp}
    cp -a $BUILD_PATH/rpi-firmware/vc/${FPTYPE}/opt/vc $ROOT_PATH/opt/
    if [ ${INSTALL_VC-1} -eq 1 ]; then
        echo "Installing VideoCore SDK..."
        cp -a $BUILD_PATH/rpi-firmware/vc/sdk/opt/vc $ROOT_PATH/opt/
    fi
fi

echo "Done."
