#!/bin/bash

. $(dirname $0)/../global_definitions

if [ ! $BOOT_PATH ]; then
    echo "WARNING: BOOT_PATH is not set!";
fi

if [ ! ${CONSISTENT_NETDEV_NAMING-0} -eq 1 ]; then
    # See https://raspberrypi.stackexchange.com/questions/43560/raspberry-pi-3-eth0-wrongfully-named-enx
    cmdline_ext="net.ifnames=0 biosdevname=0";
fi

ROOT_PART=${ROOT_PART-/dev/mmcblk0p2}
cmdline="dwc_otg.lpm_enable=0 console=tty1 $cmdline_ext root=$ROOT_PART rootfstype=$FSTYPE elevator=deadline fsck.repair=yes rootwait"

echo "Writing $BOOT_PATH/cmdline.txt"
echo $cmdline > $BOOT_PATH/cmdline.txt

echo "Writing $BOOT_PATH/config.txt"

(
cat << EOF
# For more options and information see
# http://rpf.io/configtxt
# Some settings may impact device functionality. See link above for details
# uncomment if you get no picture on HDMI for a default "safe" mode
#hdmi_safe=1
# uncomment this if your display has a black border of unused pixels visible
# and your display can output without overscan
#disable_overscan=1
# uncomment the following to adjust overscan. Use positive numbers if console
# goes off screen, and negative if there is too much border
#overscan_left=16
#overscan_right=16
#overscan_top=16
#overscan_bottom=16
# uncomment to force a console size. By default it will be display's size minus
# overscan.
#framebuffer_width=1280
#framebuffer_height=720
# uncomment if hdmi display is not detected and composite is being output
#hdmi_force_hotplug=1
# uncomment to force a specific HDMI mode (this will force VGA)
#hdmi_group=1
#hdmi_mode=1
# uncomment to force a HDMI mode rather than DVI. This can make audio work in
# DMT (computer monitor) modes
#hdmi_drive=2
# uncomment to increase signal to HDMI, if you have interference, blanking, or
# no display
#config_hdmi_boost=4
# uncomment for composite PAL
#sdtv_mode=2
#uncomment to overclock the arm. 700 MHz is the default.
#arm_freq=800
# Uncomment some or all of these to enable the optional hardware interfaces
#dtparam=i2c_arm=on
#dtparam=i2s=on
#dtparam=spi=on
# Uncomment this to disable the Bluetooth module on /dev/ttyAMA0
#dtoverlay=pi3-miniuart-bt
# Uncomment this to enable the lirc-rpi module
#dtoverlay=lirc-rpi
# Additional overlays and parameters are documented /boot/overlays/README
# Enable audio (loads snd_bcm2835)
dtparam=audio=on

# NOOBS Auto-generated Settings:
#hdmi_force_hotplug=1
#enable_uart0=1

# 3D Acceleration
#start_x=1
#dtoverlay=vc4-kms-v3d
# Support camera
#gpu_mem=128

EOF
) > $BOOT_PATH/config.txt

echo "Done."
