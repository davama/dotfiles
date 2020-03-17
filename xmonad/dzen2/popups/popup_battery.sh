#!/bin/bash

source ~/.xmonad/dzen2/source-config.sh

xaxis=$(xdotool getmouselocation | awk '{print $1}' | cut -d':' -f2)
yaxis=$(xdotool getmouselocation | awk '{print $1}' | cut -d':' -f2)

if [ $PX -eq 0 ] && [ $PY -eq 0 ]; then
	yaxis="25"
fi


WIDTH="100"
LINES="2"

battime=$(acpi -b | sed -n "1p" | awk -F " " '{print $5}')
batperc=$(acpi -b | sed -n "1p" | awk -F " " '{print $4}' | head -c3)
batstatus=$(acpi -b | cut -d',' -f1 | awk -F " " '{print $3}')

(
	echo "Battery"
	echo "$batstatus"
	echo "$battime left"
	sleep $T
) | dzen2 -xs 3 -fg $FG -bg  $BG -fn $FONT -x $xaxis -y $yaxis -w $WIDTH -l $LINES -e 'onstart=uncollapse;button1=exit;button3=exit'
