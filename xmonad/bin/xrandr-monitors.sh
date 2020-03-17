#!/bin/bash

# files uesd in monitor control keybinding

# mod + ctrl + shift + PrintKey, then a or p or s

ACTIVE_MONITORS_COUNT=$(xrandr --listactivemonitors | head -1 | awk '{print $NF}')
echo $ACTIVE_MONITORS_COUNT > /tmp/active_monitors
if [ $ACTIVE_MONITORS_COUNT -eq 1 ]; then
	xrandr -q | grep conne | grep -v dis | grep pri | awk '{print $1}' > /tmp/first
elif [ $ACTIVE_MONITORS_COUNT -eq 2 ]; then
	xrandr -q | grep conne | grep -v dis | grep pri | awk '{print $1}' > /tmp/first
	xrandr -q | grep conne | grep -v dis | grep -v pri | awk '{print $1}' > /tmp/second
elif [ $ACTIVE_MONITORS_COUNT -eq 3 ]; then
	xrandr -q | grep conne | grep -v dis | grep pri | awk '{print $1}' > /tmp/first
	xrandr -q | grep conne | grep -v dis | grep -v pri | sed '2q;d' | awk '{print $1}' > /tmp/second
	xrandr -q | grep conne | grep -v dis | grep -v pri | tail -1 | awk '{print $1}' > /tmp/third
else
	:
fi
