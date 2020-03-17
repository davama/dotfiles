#!/bin/bash

# source script for many other scripts
# TODO: improve this

# interface name of "state UP" insterface might have issue with wifi
ETHNAME=$(ip link | grep "state UP" | awk '{print $2}' | cut -d':' -f1 | head -1)

ACTIVE_MONITORS_COUNT=$(xrandr --listactivemonitors | head -1 | awk '{print $NF}')
FG='#FFFFFF'			# foreground color
BG='#312929'			# background color
FONT="Fixed:size=10"
T="2"				# sleep time
DZEN_HEIGHT=13			# height for dzen bars

PX=$(xrandr -q | grep connected | grep -oE "[0-9]\w.*\+[0-9]\+[0-9]" | head -1 | cut -d'+' -f1 | cut -d'x' -f1)
PY=$(xrandr -q | grep connected | grep -oE "[0-9]\w.*\+[0-9]\+[0-9]" | head -1 | cut -d'+' -f1 | cut -d'x' -f2)

PXhalf=$(($PX/2))
PYhalf=$(($PY/2))

if [ $ACTIVE_MONITORS_COUNT -ne 1 ]; then
	PY=0
fi
