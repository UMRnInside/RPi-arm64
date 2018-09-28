#!/bin/bash
# Features borrowed from Raspbian

. $(dirname $0)/../global_definitions

# raspberrypi-net-mods.service depends on dhcpcd5 package
for _svc in utils/raspbian_services.files/*.service
do
    test -e ${_svc} || continue
    _svc_name=$(basename ${_svc})
    echo "Installing ${_svc_name} ..."
    install -m 0644 -v ${_svc} $ROOT_PATH/lib/systemd/system/
    echo "Enable ${_svc_name} ..."
    ( cd $ROOT_PATH/etc/systemd/system/multi-user.target.wants/ && \
        ln -sf /lib/systemd/system/${_svc_name}  . )
done


echo "Setup Hostname and /etc/hosts ..."
export HOSTNAME=${HOSTNAME=raspberrypi}
chroot $ROOT_PATH  bash -c "echo ${HOSTNAME} > /etc/hostname"
chroot $ROOT_PATH  bash -c "echo '127.0.1.1 ${HOSTNAME}' >> /etc/hosts"


echo "Installing extra packages : "
echo "  rfkill : WiFI controlling..."
echo "  avahi-daemon : Aoto Discovery... (default service enabled)"
echo "  ntpdate : time keeping (when interface UP)"
chroot $ROOT_PATH apt install -y ntpdate rfkill avahi-daemon dhcpcd5 
#can't find dhcpcd5
chroot $ROOT_PATH apt install -y sudo usbutils wireless-tools bash-completion net-tools

# User:pi add to sudoers
if [ $CONFIG_SUDO -eq 1 ]; then
    echo 'pi ALL=(ALL:ALL) ALL' > $ROOT_PATH/etc/sudoers.d/00_pi
    chmod 0440                    $ROOT_PATH/etc/sudoers.d/00_pi
fi
