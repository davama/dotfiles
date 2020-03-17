#!/bin/bash -

# runs before xmonad restart/logout/poweroff, keybinding

case $1 in
	q)	MSG="Logging Out..."; COLOR="green";;
	r)	MSG="Restarting..."; COLOR="gray";;
	p)	MSG="Powering Off..."; COLOR="red";;
	*)	exit 1;;
esac


echo $MSG | osd_cat --font 9x15bold --delay 2 --outline 3 --colour $COLOR -p middle -A center &
sleep 2
