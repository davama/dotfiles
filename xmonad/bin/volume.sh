#!/bin/bash

# display volume for dzen bar


#if [ $HOSTNAME == "ARCHWORK" ]; then
#	vol=$(amixer -D pulse get Master | awk -F'[][]' '/%/ {if ($4 == "off") {print "Muted"} else { print $2} }' | tail -n 1)
#else
	vol=$(amixer get Master | awk -F'[][]' '/%/ {if ($6 == "off") { print "Muted" } else { print $2 }}' | tail -n 1)
	#vol=$(amixer get Headset | awk -F'[][]' '/%/ {if ($6 == "off") { print "Muted" } else { print $2 }}' | tail -n 1)
#fi

if [ "$#" = 0 ]; then
	echo $vol
	exit
fi

source ~/.xmonad/dzen2/source-config.sh

if [ $PX -eq 1920 ]; then
	xaxis=$(echo $((150*6)))
else
	xaxis=$(echo $((150*5)))
fi	

yaxis=$PYhalf
#FONT="Fixed:size=25"
FONT="Helvetica:size=40"

echo $vol | dzen2 -fg "#80c0ff" -bg "#000040" -fn $FONT -p 1 -x $xaxis -y $yaxis -w 150 -h 66
exit

########
# still testing bottom
########

level=$vol

# we use a fifo to buffer the repeated commands that are common with 
# volume adjustment
pipe='/tmp/volpipe'

# define some arguments passed to dzen to determine size and color.
dzen_args=( -tw 200 -h 25 -x 50 -y 50 -bg '#101010' )

# similarly for gdbar
gdbar_args=( -w 180 -h 7 -fg '#606060' -bg '#404040' )

# spawn dzen reading from the pipe (unless it's in mid-action already).
if [[ ! -e "$pipe" ]]; then
  mkfifo "$pipe"
  (dzen2 "${dzen_args[@]}" < "$pipe"; rm -f "$pipe") &
fi

# send the text to the fifo (and eventually to dzen). oss reports 
# something like "15.5" on a scale from 0 to 25 so we strip the decimals 
# and send gdbar an optional "upper limit" argument
(echo ${level/.*/} 25 | gdbar "${gdbar_args[@]}"; sleep 1) >> "$pipe"
