# RPi-arm64
Scripts, configs and hacks to make a ARM64 system for Raspberry Pi 3

Currently supported:

* **Stage 1:** Prepare and build kernel
* **Stage 2:** Build rootfs using _debootstrap_
* **Stage 3:** Install bootcode and Raspberry Pi userland
* **Stage 4:** Offline operations (like adding users)

## Simple guide
Should run as root as `sudo` does not pass env by default.

```
# Stage 1

./stage1/prepare_kernel.sh
./stage1/build_kernel.sh

# Stage 2
# Set MIRROR to your mirror site
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
#./stage2/enable_armhf.sh

# Stage 3
./stage3/bootcode_install.sh
./stage3/kernel_install.sh

# Stage 4
./stage4/passwd_root.sh
./stage4/adduser.sh pi
./stage4/setup_hostapd.sh
```

## Options
See `README.md` in every stage
