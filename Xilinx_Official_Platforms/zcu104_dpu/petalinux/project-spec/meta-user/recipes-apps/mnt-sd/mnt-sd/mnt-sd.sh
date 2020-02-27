#!/bin/sh

mount /dev/mmcblk0p1 /mnt || mount /dev/mmcblk0 /mnt > /dev/null 2>&1

if [ -x /mnt/init.sh ]
then
	echo "attempting to run /mnt/init.sh"
	source /mnt/init.sh
fi

