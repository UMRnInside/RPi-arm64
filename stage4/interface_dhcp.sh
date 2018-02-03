#!/bin/bash

. $(dirname $0)/../global_definitions

IFACE=${IFACE-eth0}

echo "This script will configure interface $IFACE"
echo "$IFACE will configure itself using DHCP"

chroot $ROOT_PATH apt-get -y install isc-dhcp-client

echo "Generating /etc/network/interfaces.d/$IFACE"

(
cat << EOF
allow-hotplug $IFACE
iface $IFACE inet dhcp

EOF
) > $ROOT_PATH/etc/network/interfaces.d/$IFACE

