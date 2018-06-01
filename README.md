# RPi-arm64
Build a Debian-based ARM64 system for Raspberry Pi 3 (including 3 B+)

Currently supported stages:

* **Stage 1:** Prepare and build kernel (Using rpi-4.14.y branch by default)
* **Stage 2:** Build rootfs using _debootstrap_ , making system **chrootable**
* **Stage 3:** Install bootcode and Raspberry Pi userland, making system **bootable**
* **Stage 4:** Offline operations (like adding users)

Currently supported features:

* On-board Wi-Fi
* Bluetooth (But `hciattach` should be run manually)
* `bcm2835_v4l2`(Camera, requires 4.12+ kernel)
* RPi.GPIO (Using [UMRnInside/RPi.GPIO](https://github.com/UMRnInside/RPi.GPIO) )

************
[中文版向导](README-ZHCN.md)

Prebuilt version can be found here: 
[Baidu Netdisk](https://pan.baidu.com/s/1hsZVl1i)

If you preferred ubuntu built by Ubuntu-Base, see [chainsx/ubuntu64-rpi](https://github.com/chainsx/ubuntu64-rpi)

## Simple guide
It is really simple...

1. Install dependencies, which goes like this on _Debian/Ubuntu_ :
```
# Debian
apt-get -y install \
    wget busybox unzip tar patch parted \
    qemu-user-static debootstrap \
    dosfstools btrfs-progs \
    make build-essential bc xxd kmod vim cmake \
    gcc-aarch64-linux-gnu g++-aarch64-linux-gnu 

# Ubuntu (16.04)
apt-get -y install \
    wget busybox unzip tar patch parted \
    qemu-user-static debootstrap \
    dosfstools btrfs-tools \
    make build-essential bc kmod vim cmake \
    gcc-aarch64-linux-gnu g++-aarch64-linux-gnu 
```

2. `./build.sh`
3. Have a cup of tea of coffee...

But, if you want to modify some configuations...

1. `cp rpi3_defconfig config`
2. edit `config`
3. `./build.sh`
4. Have a cup of tea/coffee/cola...

> ご注文は うさぎ ですか？

> Is the Order a Rabbit?

## Docker build
1. `cp rpi3_defconfig config`
2. edit `config` on demand
3. `./build_docker.sh`

## Options
See `README.md` in every stage, or read `rpi3_defconfig`
