# Stage 3
```
./stage3/bootcode_install.sh
./stage3/kernel_install.sh
```
## Requirements:
* Proper `BOOT_PATH` and `ROOT_PATH` on every script, the default value is OK.

## Options:
### `FETCH_METHOD`
The same as `./stage1/prepare_kernel.sh`

Bootcode from [Hexxeh/rpi-firmware](https://github.com/Hexxeh/rpi-firmware)

### `ROOT_PATH` and `BOOT_PATH`
Specify root path and boot path.

    sudo BOOT_PATH=/media/boot ./stage3/kernel_install.sh
    sudo BOOT_PATH=/media/boot ROOT_PATH=/media/root ./stage3/bootcode_install.sh

### `INSTALL_VC`
Set to 0 if you do not need VideoCore libraries in `/opt/vc`

    sudo BOOT_PATH=/media/boot ROOT_PATH=/media/root INSTALL_VC=1 ./stage3/bootcode_install.sh

### `INSTALL_VC_SDK`
Set to 0 if you do not need VideoCore SDK and headers

    sudo INSTALL_VC=1 INSTALL_VC_SDK=1 ./stage3/bootcode_install.sh

### `FPTYPE`
Alternatives:

* `hardfp` (**Default**), require **armhf** support
* `softfp`, require **armel** support


    sudo FPTYPE=hardfp ./stage3/bootcode_install.sh

### `CONSISTENT_NETDEV_NAMING`
Set to 1 if you want to enable _Consistent Network device naming_.
It does not affect _wlan0_

e.g. `enxaabbccddee22: renamed from eth0`

See [This page](https://raspberrypi.stackexchange.com/questions/43560/raspberry-pi-3-eth0-wrongfully-named-enx) for more information.

    CONSISTENT_NETDEV_NAMING=0 ./stage3/create_bootconf.sh

