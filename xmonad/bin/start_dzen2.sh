#!/bin/bash

# second-half of primary bar and full secondary bar

source ~/.xmonad/dzen2/source-config.sh

WIDTH=$PXhalf
HEIGHT=$PXhalf
	
# number of monitors
if [ $ACTIVE_MONITORS_COUNT -eq 1 ]; then
	monitor=1
elif [ $ACTIVE_MONITORS_COUNT -eq 2 ]; then
	monitor=1
elif [ $ACTIVE_MONITORS_COUNT -eq 3 ]; then
	monitor=3
else 
	:
fi

# bar 1 next to bar 0 which is output from xmonad
conky -c ~/.xmonad/dzen2/conkydzen1 | dzen2 -dock -xs 2 -x $PYhalf -y $PY -h $DZEN_HEIGHT -w $PYhalf -fg $FG -bg $BG -fn $FONT -ta r -e '' &

if [ $HOSTNAME == "ARCHWORK"]; then
	conky_file=~/.xmonad/dzen2/conkydzen2
else
	conky_file=~/.xmonad/dzen2/conkydzen2-teamam
fi
# just one bar with all info on the center
conky -c $conky_file | dzen2 -dock -xs 2 -x '0' -y 1080 -h $DZEN_HEIGHT -fg $FG -bg $BG -fn $FONT -e ''
