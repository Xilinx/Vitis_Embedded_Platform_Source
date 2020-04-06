#!/bin/sh

# Execute userhook if present
USERHOOK=/etc/trd/autostart.sh
USERHOOK_SD=/media/card/autostart.sh
if [ -f $USERHOOK_SD ]; then
	sh $USERHOOK_SD &
elif [ -f $USERHOOK ]; then
	sh $USERHOOK &
fi
