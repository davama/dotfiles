#!/bin/bash

source ~/.xmonad/dzen2/source-config.sh

xaxis=$(xdotool getmouselocation | awk '{print $1}' | cut -d':' -f2)

if [ $PX -eq 0 ] && [ $PY -eq 0 ]; then
	yaxis="25"
fi

FREE=`free -mh | grep Mem | cut -d':' -f2 | awk '{print $3}'`
TOTAL=`free -mh | grep Mem | cut -d':' -f2 | awk '{print $1}'`
LINES="2"

PERCBAR=`echo -e "$PERC" | gdbar -bg $BG -fg $FG -h 1 -w 50`

(
	echo "Memory"
	echo "Total: $TOTAL"
	echo "Free: $FREE"
	sleep $T
) | dzen2 -xs 3 -fg $FG -bg $BG -fn $FONT -x $xaxis -y '13' -w "100" -l $LINES -ta 'c' -sa 'l' -e 'onstart=uncollapse;button1=exit;button3=exit'
