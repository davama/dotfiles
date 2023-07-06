#!/bin/bash

# script to output name of network interface
# if wifi also output signal strength

# manually set physical interface and wireless interface name to 'net0' and 'wifi0' upon ARCH build
eth="net0"
weth="wifi0"

wifi_exist=$(ip link | grep -vE "lo:|tun0:" | grep -E "^[[:digit:]]" | grep -v net0 | cut -d: -f2)

if [ -s $wifi_exist ]; then
	# check if wifi connected if any
	VAR=$(iwconfig $weth | head -1)
fi

# show SSID and signal strength
function wifi_stngth () {
	# get SSID name
	essid=$(iwconfig $weth | head -1 | grep ESSID | cut -d: -f2 | tail -1 | sed 's/"//g')
	# get signal strength; raw
	stngth=$(iwconfig $weth | grep Quality | awk '{ print $2 }' | cut -d'=' -f2 | cut -d'/' -f1)
	# divide by 10
	bars=$(expr $stngth / 10)
	case $bars in
		0)  bar='[-------]' ;;
		1)  bar='[/------]' ;;
		2)  bar='[//-----]' ;;
		3)  bar='[///----]' ;;
		4)  bar='[////---]' ;;
		5)  bar='[/////--]' ;;
		6)  bar='[//////-]' ;;
		7)  bar='[///////]' ;;
		*)  bar='[--!!--]' ;;
	esac
}

# if wired connection
ip link | grep $eth | grep -q "state UP" && echo Wired && exit 0

# if wifi connection; show SSID and strength
case $VAR in 
	*off*)	exit 0;;
	*)	wifi_stngth;;
esac

echo $essid $bar
