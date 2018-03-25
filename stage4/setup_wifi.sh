#!/bin/bash

. $(dirname $0)/../global_definitions

(
cat << EOF
auto wlan0
iface wlan0 inet dhcp
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf

EOF
) > $ROOT_PATH/etc/network/interfaces.d/wlan0
