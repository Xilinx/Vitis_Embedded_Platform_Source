#!/bin/sh

# Source environment for init script
source /etc/profile

# Set console loglevel to KERN_INFO
echo "Setting console loglevel to 0 ..."
echo "0" > /proc/sys/kernel/printk

# add /media/card to library search path
echo '/media/card' >> /etc/ld.so.conf
echo '/media/card/lib' >> /etc/ld.so.conf
/sbin/ldconfig

# Check if R5 firmware present in sdcard
if [ -f "/media/card/perfapm-server.elf" ]; then
	# Udev loads zynqmp_r5_remoteproc driver automatically.
	# Load remaining driver here
	/sbin/modprobe rpmsg_user_dev_driver
	# Provide name of  R5 firmware to zynqmp_r5_remoteproc driver
	mkdir -p /lib/firmware
	cp /media/card/perfapm-server.elf /lib/firmware/
	echo perfapm-server.elf > /sys/class/remoteproc/remoteproc0/firmware
fi

if [ -f "/media/card/init.sh" ]; then
        echo "attempting to run /media/card/init.sh"
        source /media/card/init.sh
fi


# Wake up HDMI monitor
modetest -D b00c0000.v_mix > /dev/null 2>&1 &
sleep 1

# Auto-start base TRD application if present
vqt2=$(which video_qt2)
if [ $? -eq 0 ] && [ -f /etc/X11/xorg.conf ]; then
	run_video.sh &
fi
