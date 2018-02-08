# RPi-arm64
Scripts, configs and hacks to make a ARM64 system for Raspberry Pi 3

Currently supported:

* **Stage 1:** Prepare and build kernel (Using rpi-4.12.y branch by default)
* **Stage 2:** Build rootfs using _debootstrap_ , making system **chrootable**
* **Stage 3:** Install bootcode and Raspberry Pi userland, making system **bootable**
* **Stage 4:** Offline operations (like adding users)

************
[中文版向导](https://github.com/UMRnInside/RPi-arm64/blob/master/README-CN.md)

Prebuilt version can be found here: 
[Baidu Netdisk](https://pan.baidu.com/s/1hsZVl1i)

If you preferred ubuntu built by Ubuntu-Base, see [chainsx/ubuntu64-rpi](https://github.com/chainsx/ubuntu64-rpi)

## Simple guide
Should run as root as `sudo` does not pass env by default.

```
# If you want to generate an image file
./utils/dist_partimage.sh

LOOPDEV=$(losetup -f)
losetup $LOOPDEV RPi-arm64-dist.img
partprobe $LOOPDEV
mkfs.vfat -n BOOT ${LOOPDEV}p1
mkfs.btrfs -L ROOTFS ${LOOPDEV}p2

mount ${LOOPDEV}p1 ./dist/boot
mount ${LOOPDEV}p2 ./dist/rootfs

# Stage 1

./stage1/prepare_kernel.sh
./stage1/build_kernel.sh

# Stage 2
# Optional: Set MIRROR to your mirror site
#MIRROR="http://mirrors.ustc.edu.cn/debian/"

./stage2/root_debootstrap.sh
./stage2/install_kernel.sh
./stage2/enable_openssh.sh

# Package firmware-brcm80211 is NON-FREE, but MAIN in archive.raspberrypi.org
# firmware-brcm80211 will be retrived from archive.raspberrypi.org
# Set FWURL to overwrite it
#FWURL=http://example.org/firmware-brcm80211_all.deb

./stage2/enable_nonfree.sh
./stage2/install_firmware_brcm.sh

# Optional
#./stage2/enable_armhf.sh
#./stage2/enable_armel.sh

# Stage 3
./stage3/bootcode_install.sh
./stage3/kernel_install.sh
./stage3/create_bootconf.sh
./stage3/create_fstab.sh

# Stage 4
# Set root password and add new user
./stage4/passwd_root.sh
./stage4/adduser.sh pi

# If you want a hotspot
./stage4/setup_hostapd.sh
# If you want ethernet access
./stage4/interface_dhcp.sh
# If you are building an image
./stage4/deploy_init_resizer.sh
```

## Options
See `README.md` in every stage
