# RPi-arm64
Scripts, configs and hacks to make a ARM64 system for Raspberry Pi 3

## Building Kernel
Run `build_kernel.sh`
Args:
### ARCH
Select specified ARCH to build [Default arm64]
`ARCH=arm64 ./build_kernel.sh`
### CROSS_COMPILE
Specify toolchain to use [Default aarch64-linux-gnu- ]
`CROSS_COMPILE=aarcch64-linux-gnu- ./build.sh`
## BUILD_PATH
Specify place to put the kerneli [Default $(pwd)/build ]
`BUILD_PATH=./build ./build_kernel.sh`
## SKIP_KERNELFETCH
Skip kernel fetch.
`SKIP_KERNELFETCH=1 ./build_kernel.sh`
