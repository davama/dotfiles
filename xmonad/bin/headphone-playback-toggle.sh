#!/bin/bash


function mute () {
	amixer -c $c set $device playback mute &> /dev/null
}
function unmute () {
	amixer -c $c set $device playback unmute &> /dev/null
}
function dev_check {
	if [[ $device == "" ]]; then
		return
	elif amixer -c $c | sed -n '/Head/,/Simple/p' | grep -q off; then
		unmute
		echo $device is on
	elif amixer -c $c | sed -n '/Head/,/Simple/p' | grep -q on; then
		mute
		echo $device is off
	else
		return
	fi
}

# get number of cards
for c in $(aplay -l | grep card | cut -d':' -f1 | awk '{print $NF}' | sort | uniq); do
	device=$(amixer -c $c | grep Headp | cut -d"'" -f2 | sed 's/+.*//g' | sort | uniq)
	dev_check
	device=$(amixer -c $c | grep Heads | cut -d"'" -f2 | sed 's/+.*//g' | sort | uniq)
	dev_check
done

#amixer -c 0 | sed -n '/Head/,/Simple/p'
#amixer -c 1 | sed -n '/Head/,/Simple/p'
