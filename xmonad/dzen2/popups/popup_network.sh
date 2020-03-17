#!/bin/bash

source ~/.xmonad/dzen2/source-config.sh

xaxis=$(xdotool getmouselocation | awk '{print $1}' | cut -d':' -f2)

function wired () {

WIDTH="180"

mac=$(ip addr show $ETHNAME | grep "link/ether" | awk '{print $2}')
linkl=$(ip addr show | grep inet6 | grep link | awk '{print $2}')

(
	echo "Network on $ETHNAME"
	for i in $(ip link | grep BROAD | awk '{print $2}' | cut -d':' -f1 | cut -d'@' -f1); do ip addr show $i | grep global | awk '{print $2}'; done
	echo "MAC: $mac"
	echo "LL: $linkl"
	sleep $T
) | dzen2 -xs 3 -bg $BG -fg $FG -fn $FONT -x $xaxis -y '13' -w "325" -l "5" -ta 'c' -sa 'l' -e 'onstart=uncollapse;button1=exit;button3=exit'
}


function wireless () {

WIDTH="280"
LINES="8"

essid=$(iwconfig $ETHNAME | sed -n "1p" | awk -F '"' '{print $2}')
mode=$(iwconfig $ETHNAME | sed -n "1p" | awk -F " " '{print $3}')
freq=$(iwconfig $ETHNAME | sed -n "2p" | awk -F " " '{print $2}' | cut -d":" -f2)
mac=$(iwconfig $ETHNAME | sed -n "2p" | awk -F " " '{print $6}')
qual=$(iwconfig $ETHNAME | sed -n "6p" | awk -F " " '{print $2}' | cut -d"=" -f2)
lvl=$(iwconfig $ETHNAME | sed -n "6p" | awk -F " " '{print $4}' | cut -d"=" -f2)
rate=$(iwconfig $ETHNAME | sed -n "3p" | awk -F "=" '{print $2}' | cut -d" " -f1)
inet4=$(ip addr show $ETHNAME | grep "scope global $ETHNAME" | awk '{print $2}')
inet6=$(ip addr show $ETHNAME | grep inet6 | grep global | awk '{print $2}')
mac=$(ip addr show $ETHNAME | grep "link/ether" | awk '{print $2}')
linkl=$(ip addr show $ETHNAME | grep inet6 | grep link | awk '{print $2}')

(
	echo "Network on $ETHNAME"
	echo "SSID: $essid"
	echo "Freq: $freq GHz Band: $mode"
	echo "Down: $rate MB/s Quality: $qual"
	echo "IP: $inet4"
	echo "IPv6: $inet6"
	echo "MAC: $mac"
	echo "LL: $linkl"
	sleep $T
) | dzen2 -xs 3 -fg $FG -bg $BG -fn $FONT -x $xaxis -y '13' -w $WIDTH -l $LINES -e 'onstart=uncollapse;button1=exit;button3=exit'
}


if ip addr show | grep "state UP" | awk '{print $2}'| cut -d':' -f1 | head -1 | grep -q net0; then
	wired
else
	wireless
fi
