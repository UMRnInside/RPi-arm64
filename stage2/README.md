# Stage 2
```
# Suppose you are root
# MUST run first
./stage2/root_debootstrap.sh

# Install kernel
./stage2/install_kernel.sh

# Package firmware-brcm80211 is NON-FREE
./stage2/enable_nonfree.sh
./stage2/install_firmware_brcm.sh

# Optional
# They allow you to run dynamically linked armhf/armel binaries
# Uncomment the folling lines to enable them
#./stage2/enable_armhf.sh
#./stage2/enable_armel.sh

```

## Requirements
* Running as root
* `debootstrap`, `cdebootstrap` or `cdebootstrap-static`
* `chroot`
* Running on ARM64 platform, or `qemu-aarch64-static` avalable in `PATH`

## Options
### `ROOT_PATH`
Specify where to make rootfs.
It can be manually moved to other places [Default ./dist/rootfs/]

**NOTE:** You should specify it in the whole stage

    sudo ROOT_PATH=./dist/rootfs ./stage2/root_debootstrap.sh

### `DEBOOTSTRAP_BIN`
Specify which debootstrap to use. [Default $(which cdebootstrap)]

    sudo DEBOOTSTRAP_BIN=/usr/bin/cdebootstrap ./stage2/root_debootstrap.sh

### `DEB_ARGS`
Specify arguments to pass to debootstrap [Default ""]

    sudo DEBOOTSTRAP_BIN=/usr/bin/cdebootstrap DEB_ARGS="--verbose" ./stage2/root_debootstrap.sh


### `MIRROR`
Specify mirror site to use [Default http://httpredir.debian.org/debian/]

**NOTE:** `enable_nonfree.sh` will **OVERWRITE sources.list** in `$ROOT_PATH`

    sudo MIRROR="https://mirrors.ustc.edu.cn/debian/" ./stage2/root_debootstrap.sh
    sudo MIRROR="https://mirrors.ustc.edu.cn/debian/" ./stage2/enable_nonfree.sh

### `SUITE`
Specify the suite to be installed, depend on `debootstrap` [Default stable]

    sudo SUITE=stable ./stage2/root_debootstrap.sh
    sudo SUITE=stable ./stage2/enable_nonfree.sh

### `DEB_INCLUDE`
Include certain packets. [Default ""]

    sudo DEB_INCLUDE=vim,wpasupplicant,hostapd,udhcpd ./stage2/root_debootstrap.sh

### `SKIP_APTUPDATE`
Set to 1 if you want to skip first `apt-get update` [Default ""]

    sudo SKIP_APTUPDATE=1 ./stage2/root_debootstrap.sh


