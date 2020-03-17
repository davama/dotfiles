#!/bin/bash

if [[ $HOSTNAME == "ARCH" ]]; then
	sleep 3
	xrandr --output HDMI2 --auto
	sleep 2
	xrandr --output HDMI2 --right-of HDMI1
elif [[ $HOSTNAME == "ARCHWORK" ]]; then
	:
#	sleep 3
	xrandr --output DVI-I-1-1 --auto 
	#sleep 2
	#xrandr --output DVI-I-1-1 --right-of eDP-1
	xrandr --output DVI-I-1-1 --mode "1920x1080" --right-of eDP-1
else
	:
fi
