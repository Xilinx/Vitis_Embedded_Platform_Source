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
# Copy gst sdx libraries and plugins
cp -f /media/card/lib/* /usr/lib &> /dev/null
cp -f /media/card/gstreamer-1.0/* /usr/lib/gstreamer-1.0 &> /dev/null
cp -f /media/card/libdpu* /usr/lib &> /dev/null

# Wake up HDMI monitor
modetest -D b00c0000.v_mix > /dev/null 2>&1 &
sleep 1
