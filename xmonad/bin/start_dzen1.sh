#!/bin/bash

# primary bar
# output from xmonad loggin pp

source ~/.xmonad/dzen2/source-config.sh
# font found http://www.ambor.com/hb/dice.ttf
FONT="Dice:size=10:antialias=true"	# font 
#FONT="Fixed:size=10:antialias=true"	# debug
WIDTH=$PXhalf

# number of monitors
if [ $ACTIVE_MONITORS_COUNT -eq 1 ]; then
	dzen2 -dock -xs 1 -x '0' -y $PY -h $DZEN_HEIGHT -w $WIDTH -fg $FG -bg $BG -fn $FONT -ta l -e ''
elif [ $ACTIVE_MONITORS_COUNT -eq 2 ]; then
	dzen2 -dock -xs 2 -x '0' -y '0' -h $DZEN_HEIGHT -w $WIDTH -fg $FG -bg $BG -fn $FONT -ta l -e ''
elif [ $ACTIVE_MONITORS_COUNT -eq 3 ]; then
	dzen2 -dock -xs 2 -x '0' -y $PY -h $DZEN_HEIGHT -w $PYhalf -fg $FG -bg $BG -fn $FONT -ta l -e ''
else
	:
fi
