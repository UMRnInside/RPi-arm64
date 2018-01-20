# RPi-arm64
Scripts, configs and hacks to make a ARM64 system for Raspberry Pi 3

Currently supported:

* **Stage 1:** Prepare and build kernel
* **Stage 2:** Build rootfs using _debootstrap_

## Stage 1
```
./stage1/prepare_kernel.sh
./stage1/build_kernel.sh
```

### Requirements
* Utils like
    * git
    * patch
    * etc...
* a cross-compile toolchain, like
    * _aarch64-linux-gnu-_ on Debian by installing `gcc-aarch64-linux-gnu`

### Options
#### `FETCH_METHOD`
Specify way to fetch kernel source code [Default git]

Alternatives (**Case SENSITIVE**):

* git
* wget

    FETCH_METHOD=wget ./stage1/prepare_kernel.sh

#### `ARCH`
Select specified ARCH to build [Default arm64]

    ARCH=arm64 ./stage1/build_kernel.sh
#### `CROSS_COMPILE`
Specify toolchain to use [Default aarch64-linux-gnu- ]

    CROSS_COMPILE=aarcch64-linux-gnu- ./stage1/build_kernel.sh
#### `JOBCOUNT`
Passed to `make -j ` [Default $(nproc)]

    JOBCOUNT=4 ./stage1/build_kernel.sh

#### `BUILD_PATH`
Specify place to put the kerneli [Default build ]

    BUILD_PATH=./build ./stage1/build_kernel.sh
#### `SKIP_KERNELFETCH`
Skip kernel fetch.

    SKIP_KERNELFETCH=1 ./stage1/build_kernel.sh

### Extra info:
`build_kernel.sh` will apply some fixes, for more details see

 * [Issue 2117](https://github.com/raspberrypi/linux/issues/2117)
 * [Issue 2124](https://github.com/raspberrypi/linux/issues/2124)
 * [Issue 2136](https://github.com/raspberrypi/linux/issues/2136)

## Make rootfs
```
# Suppose you are root
# MUST run first
./stage2/root_debootstrap.sh

# Install kernel
./stage2/install_kernel.sh

# Package firmware-brcm80211 is NON-FREE
./stage2/enable_nonfree.sh
./stage2/install_firmware_apt.sh

# Optional
# They allow you to run dynamically linked armhf/armel binaries
# Uncomment the folling lines to enable them
#./stage2/enable_armhf.sh
#./stage2/enable_armel.sh

```

### Requirements
* Running as root, for example,
    * `sudo ./stage2/root_debootstrap.sh`
    * `su`
* `debootstrap`
* `chroot`
* Running on ARM64 platform, or `qemu-aarch64-static` avalable in `PATH`

### Options
#### `ROOT_PATH`
Specify where to make rootfs.
It can be manually moved to other places [Default ./dist/rootfs/]

**NOTE:** You should specify it in the whole stage

    sudo ROOT_PATH=./dist/rootfs ./stage2/root_debootstrap.sh

#### `MIRROR`
Specify mirror site to use [Default http://httpredir.debian.org/debian/]

**NOTE:** `enable_nonfree.sh` will **OVERWRITE sources.list** in `$ROOT_PATH`

    sudo MIRROR="https://mirrors.ustc.edu.cn/debian/" ./stage2/root_debootstrap.sh
    sudo MIRROR="https://mirrors.ustc.edu.cn/debian/" ./stage2/enable_nonfree.sh

#### `SUITE`
Specify the suite to be installed, depend on `debootstrap` [Default stable]

    sudo SUITE=stable ./stage2/root_debootstrap.sh
    sudo SUITE=stable ./stage2/enable_nonfree.sh

#### `DEB_INCLUDE`
Include certain packets. [Default ""]

    sudo DEB_INCLUDE=vim,wpasupplicant,hostapd,udhcpd ./stage2/root_debootstrap.sh
