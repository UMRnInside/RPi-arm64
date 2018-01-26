# Stage 1
```
./stage1/prepare_kernel.sh
./stage1/build_kernel.sh
```

## Requirements
* Utils like
    * git
    * patch
    * etc...
* a cross-compile toolchain, like
    * _aarch64-linux-gnu-_ on Debian by installing `gcc-aarch64-linux-gnu`

## Options
### `FETCH_METHOD`
Specify way to fetch kernel source code [Default wget]

    FETCH_METHOD=wget ./stage1/prepare_kernel.sh

### `LINUX_BRENCH`
Specify branch name [Default rpi-4.12.y]

    LINUX_BRANCH=rpi-4.12.y ./stage1/prepare_kernel.sh

### `ARCH`
Select specified ARCH to build [Default arm64]

    ARCH=arm64 ./stage1/build_kernel.sh
### `CROSS_COMPILE`
Specify toolchain to use [Default aarch64-linux-gnu- ]

    CROSS_COMPILE=aarcch64-linux-gnu- ./stage1/build_kernel.sh
### `JOBCOUNT`
Passed to `make -j ` [Default $(nproc)]

    JOBCOUNT=4 ./stage1/build_kernel.sh

### `BUILD_PATH`
Specify place to put the kernel [Default build ]

    BUILD_PATH=./build ./stage1/build_kernel.sh
### `SKIP_KERNELFETCH`
Skip kernel fetch.

    SKIP_KERNELFETCH=1 ./stage1/build_kernel.sh

## Extra info:
`prepare_kernel.sh` will apply some fixes, for more details see

 * [Issue 2117](https://github.com/raspberrypi/linux/issues/2117)
 * [Issue 2124](https://github.com/raspberrypi/linux/issues/2124)
 * [Issue 2136](https://github.com/raspberrypi/linux/issues/2136)

