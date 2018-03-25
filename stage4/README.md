# Stage 4
```
./stage4/passwd_root.sh
./stage4/adduser.sh pi
./stage4/setup_hostapd.sh
```
## Requirements:
* Proper `BOOT_PATH` and `ROOT_PATH` on every script, the default value is OK.
* Running as root

## Options:
### `IFACE`
Specify WLAN interface for hostapd.
`wlan0` would work fine in most cases.

    sudo IFACE=wlan0 ./stage4/setup_hostapd.sh

### `SSID` and `PSK`
Specify SSID and PSK for hostapd.
Random values will be generated if it's empty.

    sudo SSID=Test PSK=changeme ./stage4/setup_hostapd.sh

### `IPADDR`
Specify IP Address [Default 172.16.233.1]

    sudo IPADDR=172.16.233.1 ./stage4/setup_hostapd.sh

### `ROOT_BLKDEV`
Specify root block device name, **NOT ROOT PARTITION**

e.g. `/dev/mmcblk0`

    sudo ROOT_BLKDEV=/dev/mmcblk0 ./stage4/deploy_init_resizer.sh

### `RESIZEFS_FIRSTBOOT`
Resizes filesystem on first boot [Default 1]

    sudo ROOT_BLKDEV=/dev/mmcblk0 RESIZEFS_FIRSTBOOT=1 ./stage4/deploy_init_resizer.sh

### `FSTYPE`
Specify filesystem type [Default btrfs]

    sudo FSTYPE=btrfs ./stage4/deploy_init_resizer.sh

### `AUTOMODE`
Set to 1 to automatically add user/change password [Default 0]

    sudo AUTOMODE=1 ./stage4/adduser.sh pi
    sudo AUTOMODE=1 PASSWORD=raspberry ./stage4/root_passwd.sh 

### `PASSWORD`
Set password in auto mode.

    sudo AUTOMODE=1 PASSWORD=raspberry ./stage4/adduser.sh pi
    sudo AUTOMODE=1 PASSWORD=raspberry ./stage4/root_passwd.sh 

