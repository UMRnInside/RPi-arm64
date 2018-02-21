# RPi-arm64
Scripts, configs and hacks to make a ARM64 system for Raspberry Pi 3

Currently supported:

* **Stage 1:** Prepare and build kernel (Using rpi-4.12.y branch by default)
* **Stage 2:** Build rootfs using _debootstrap_ , making system **chrootable**
* **Stage 3:** Install bootcode and Raspberry Pi userland, making system **bootable**
* **Stage 4:** Offline operations (like adding users)

************
[中文版向导](https://github.com/UMRnInside/RPi-arm64/blob/Docker-compatibility/README-CN.md)

Prebuilt version can be found here: 
[Baidu Netdisk](https://pan.baidu.com/s/1hsZVl1i)

If you preferred ubuntu built by Ubuntu-Base, see [chainsx/ubuntu64-rpi](https://github.com/chainsx/ubuntu64-rpi)

## Simple guide
It is really simple...

1. `./build.sh`
2. Have a cup of tea of coffee...

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
