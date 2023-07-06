#!/bin/bash

#set -x 

# hacky attempt to run cool screensaver
# move monitors to empty WS and display conky

function destroy_conky_proc () {
	ps ux | grep conky | grep greatcircle | awk '{print $2}' | xargs kill
}

#trap 'destroy_conky_proc; rm /tmp/*-$$' EXIT
trap 'destroy_conky_proc' EXIT

function monitor_1 () {
	# about bottom left hand corner of monitor 1
	xdotool mousemove 50 1010 click 1 
	# randomize which empty WS to go to
	RAN_WS=$(cat /tmp/xmonad-all-WS-$$ | awk '{print $1}' | sort -R | head -1)
	wmctrl -s $RAN_WS
	sed -i "/^$RAN_WS /d" /tmp/xmonad-all-WS-$$
	unset -v RAN_WS
}
function monitor_2 () {
	# about bottom left hand corner of monitor 2
	xdotool mousemove 3720 1010 click 1 
	RAN_WS=$(cat /tmp/xmonad-all-WS-$$ | awk '{print $1}' | sort -R | head -1)
	wmctrl -s $RAN_WS
	sed -i "/^$RAN_WS /d" /tmp/xmonad-all-WS-$$
	unset -v RAN_WS
}
function is_dual_head () {
	if xrandr | grep " connected " | wc -l | grep -q 2 ; then
		DUAL_HEAD=1 # two monitors
	else
		DUAL_HEAD=0 # single monitor
	fi
}
function lock_black () {
	xtrlock -b
	exit
}
function number_of_empty_ws () {
	NUM_EMPTY_WS=$(cat /tmp/xmonad-all-WS-$$ | wc -l)
}
wmctrl -d | awk '{print $1,$NF}' > /tmp/xmonad-all-WS-$$

# find non-empty WS
for i in $(wmctrl -lp | awk '{print $2}' | sort | uniq); do
	# remove non-empty WS
	sed -i "/^$i /d" /tmp/xmonad-all-WS-$$
done

# if all WS have windows
if ! [ -s /tmp/xmonad-all-WS-$$ ]; then
	lock_black
fi

is_dual_head
number_of_empty_ws

if [[ $DUAL_HEAD == 1 ]]; then
	# if only one WS is empty
	if [[ $NUM_EMPTY_WS == 1 ]]; then
		lock_black
	fi
	monitor_2
	monitor_1
else
	monitor_1
fi

conky -c ~/.config/conky/stats_circle/greatcircle &

xtrlock 
