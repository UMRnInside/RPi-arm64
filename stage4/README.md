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

