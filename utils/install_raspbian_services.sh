#!/bin/bash

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

