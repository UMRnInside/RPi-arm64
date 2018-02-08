# RPi-arm64
为树莓派3构建基于Debian ARM64 的操作系统。

目前支持:

* **Stage 1:** 下载、准备、编译内核
* **Stage 2:** 使用 _debootstrap_ 构建根文件系统
* **Stage 3:** 安装bootcode和VideoCore libs
* **Stage 4:** 离线操作 (例如添加用户)

************
广告:
树莓派64位系统交流群(QQ):697381661

预构建版本：[百度云](http://pan.baidu.com/s/1hsZVl1i)

## Simple guide
请以Root用户执行。

```
# 用于构建镜像
./utils/dist_partimage.sh

LOOPDEV=$(losetup -f)
losetup $LOOPDEV ./dist/RPi-arm64-dist.img
partprobe $LOOPDEV
mkfs.vfat -n BOOT ${LOOPDEV}p1
mkfs.btrfs -L ROOTFS ${LOOPDEV}p2

mount ${LOOPDEV}p1 ./dist/boot
mount ${LOOPDEV}p2 ./dist/rootfs

# Stage 1

./stage1/prepare_kernel.sh
./stage1/build_kernel.sh

# Stage 2
# 可选：设置MIRROR为您使用的镜像站点
#MIRROR="http://mirrors.ustc.edu.cn/debian/"

./stage2/root_debootstrap.sh
./stage2/install_kernel.sh
./stage2/enable_openssh.sh

# firmware-brcm80211是非自由软件包
# firmware-brcm80211 将从 archive.raspberrypi.org获取
# 设置FWURL以改变这个软件包的来源
#FWURL=http://example.org/firmware-brcm80211_all.deb

./stage2/enable_nonfree.sh
./stage2/install_firmware_brcm.sh

# 可选：支持armhf/armel
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

# 如果您需要热点
./stage4/setup_hostapd.sh
# 如果您需要以太网访问
./stage4/interface_dhcp.sh
# 如果您在构建镜像，您可能需要部署文件系统自动扩展程序
./stage4/deploy_init_resizer.sh
```

## Options
See `README.md` in every stage
