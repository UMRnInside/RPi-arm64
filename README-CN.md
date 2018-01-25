# RPi-arm64
为树莓派3构建基于Debian ARM64 的操作系统。

目前支持:

* **Stage 1:** 下载、准备、编译内核
* **Stage 2:** 使用 _debootstrap_ 构建根文件系统
* **Stage 3:** 安装bootcode和VideoCore libs
* **Stage 4:** 离线操作 (例如添加用户)

## Stage 1
```
./stage1/prepare_kernel.sh
./stage1/build_kernel.sh
```

### 运行条件
* 一些工具，比如：
    * git
    * patch
    * 等等...
* 交叉编译工具链，例如：
    * Debian上的 _aarch64-linux-gnu-_， 可以通过安装`gcc-aarch64-linux-gnu`获得

### 参数
#### `FETCH_METHOD`
指定获取内核源代码的方式 [默认值 wget]

备选项 (**大小写敏感**):

* git
* wget

    FETCH_METHOD=wget ./stage1/prepare_kernel.sh

#### `ARCH`
指定内核的目标架构 [默认值 arm64]

    ARCH=arm64 ./stage1/build_kernel.sh
#### `CROSS_COMPILE`
指定交叉编译工具链 [默认值 aarch64-linux-gnu- ]

    CROSS_COMPILE=aarcch64-linux-gnu- ./stage1/build_kernel.sh
#### `JOBCOUNT`
将向`make -j `传递 [默认值 $(nproc)]

    JOBCOUNT=4 ./stage1/build_kernel.sh

#### `BUILD_PATH`
指定暂时放置内核的位置 [默认值 build ]

    BUILD_PATH=./build ./stage1/build_kernel.sh
#### `SKIP_KERNELFETCH`
跳过内核下载.

    SKIP_KERNELFETCH=1 ./stage1/build_kernel.sh

### 其他信息:
`prepare_kernel.sh` 会修改内核配置，详见：

 * [Issue 2117](https://github.com/raspberrypi/linux/issues/2117)
 * [Issue 2124](https://github.com/raspberrypi/linux/issues/2124)
 * [Issue 2136](https://github.com/raspberrypi/linux/issues/2136)

## Stage 2
```
# 假装您使用root
# 最先运行
./stage2/root_debootstrap.sh

# 安装内核模块
./stage2/install_kernel.sh

# firmware-brcm80211 是非自由软件包
./stage2/enable_nonfree.sh
./stage2/install_firmware_brcm.sh

# 可选
# 执行它们可以使您获得armhf/armel支持
# 取消注释以启用它们
#./stage2/enable_armhf.sh
#./stage2/enable_armel.sh

```

### 运行条件
* 以root运行
* `debootstrap`
* `chroot`
* 在 ARM64 平台上运行，或者有可用的 `qemu-aarch64-static`

### 参数
#### `ROOT_PATH`
指定根文件系统安置点
它可以被手动移动至其它地方 [默认值 ./dist/rootfs/]

**注意：** 如果您没有使用默认值，请处处指定它

    sudo ROOT_PATH=./dist/rootfs ./stage2/root_debootstrap.sh

#### `MIRROR`
指定所使用的镜像源 [默认值 http://httpredir.debian.org/debian/]

**注意：** `enable_nonfree.sh` 将在`$ROOT_PATH`内**覆盖 sources.list文件**

    sudo MIRROR="https://mirrors.ustc.edu.cn/debian/" ./stage2/root_debootstrap.sh
    sudo MIRROR="https://mirrors.ustc.edu.cn/debian/" ./stage2/enable_nonfree.sh

#### `SUITE`
指定发行代号, 这取决于`debootstrap` [默认值 stable]

    sudo SUITE=stable ./stage2/root_debootstrap.sh
    sudo SUITE=stable ./stage2/enable_nonfree.sh

#### `DEB_INCLUDE`
指定预先安装的软件包. [默认值 ""]

    sudo DEB_INCLUDE=vim,wpasupplicant,hostapd,udhcpd ./stage2/root_debootstrap.sh

## Stage 3
```
./stage3/bootcode_install.sh
./stage3/kernel_install.sh
```
### 运行条件:
* 在执行每个脚本时指定恰当且相同的 `BOOT_PATH` 和 `ROOT_PATH`，可以留空以使用默认值

### 参数:
#### `FETCH_METHOD`
含义与`./stage1/prepare_kernel.sh`相同

Bootcode 来自 [Hexxeh/rpi-firmware](https://github.com/Hexxeh/rpi-firmware)

#### `ROOT_PATH` and `BOOT_PATH`
指定根目录和启动目录

    sudo BOOT_PATH=/media/boot ./stage3/kernel_install.sh
    sudo BOOT_PATH=/media/boot ROOT_PATH=/media/root ./stage3/bootcode_install.sh

#### `INSTALL_VC`
如果您不需要`/opt/vc`内的VideoCore库，请设置为0 

    sudo BOOT_PATH=/media/boot ROOT_PATH=/media/root INSTALL_VC=1 ./stage3/bootcode_install.sh

#### `FPTYPE`
可选项:

* `hardfp` (**默认值**)
    需要 **armhf** 支持
* `softfp`
    需要 **armel** 支持


    sudo FPTYPE=hardfp ./stage3/bootcode_install.sh

## Stage 4
```
./stage4/passwd_root.sh
./stage4/adduser.sh pi
./stage4/setup_hostapd.sh
```
### 运行条件:
* 在执行每个脚本时指定恰当且相同的 `BOOT_PATH` 和 `ROOT_PATH`，可以留空以使用默认值
* 以root运行

### 参数:
#### `IFACE`
指定 WLAN 接口名
大多数情况下，使用默认的`wlan0`就可以正常工作了.

    sudo IFACE=wlan0 ./stage4/setup_hostapd.sh

#### `SSID` 和 `PSK`
指定热点的名字(SSID)和口令(PSK)
否则，脚本将自行生成随机值。

    sudo SSID=Test PSK=changeme ./stage4/setup_hostapd.sh

#### `IPADDR`
指定 IP 地址 [默认值 172.16.233.1]

    sudo IPADDR=172.16.233.1 ./stage4/setup_hostapd.sh

