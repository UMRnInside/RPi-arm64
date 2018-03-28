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
    if [ ${INSTALL_VC_SDK-1} -eq 1 ]; then
        echo "Installing VideoCore SDK..."
        cp -a $BUILD_PATH/rpi-firmware/vc/sdk/opt/vc $ROOT_PATH/opt/
    fi
fi

if [ ${INSTALL_VC64:=0} -eq 1 ]; then
    echo "Installing VideoCore userland(/opt/vc) aarch64 binary..."
    ROOT_PATH=$(readlink -f ${ROOT_PATH}) # workaround, to get abs path
    pushd $BUILD_PATH
    test -d userland || git clone --depth=1 https://github.com/raspberrypi/userland
    rm -rf ./userland/build && mkdir -p ./userland/build
    pushd ./userland/build
    cmake -DCMAKE_SYSTEM_NAME=Linux -DCMAKE_BUILD_TYPE=release -DARM64=ON -DCMAKE_C_COMPILER=aarch64-linux-gnu-gcc -DCMAKE_CXX_COMPILER=aarch64-linux-gnu-g++ -DCMAKE_ASM_COMPILER=aarch64-linux-gnu-gcc -DVIDEOCORE_BUILD_DIR=/opt/vc ../
    make -j $(nproc)
    make install DESTDIR=$ROOT_PATH/
    popd
    popd

    for _bin in ${ROOT_PATH}/opt/vc/bin/* ;do
        _binbase=$(basename $_bin)
        if test -e ${_bin};then
            cd ${ROOT_PATH}/usr/bin/ && \
            ln -sf /opt/vc/bin/${_binbase} ./ && \
            echo "Symlinked /opt/vc/bin/${_binbase} ..."
        fi
    done
    echo "/opt/vc/lib/" > ${ROOT_PATH}/etc/ld.so.conf.d/vc-userland.conf
fi

echo "Done."
