#/bin/bash

source ~/.xmonad/dzen2/source-config.sh

xaxis=$(xdotool getmouselocation | awk '{print $1}' | cut -d':' -f2)
yaxis=$(xdotool getmouselocation | awk '{print $1}' | cut -d':' -f2)

HOST=$(hostname)
KERNEL=$(uname -r)
PACKAGES=$(pacman -Q | wc -l)
UPDATED=$(awk '/upgraded/ {line=$0;} END { $0=line; gsub(/[\[\]]/,"",$0); printf "%s %s",$1,$2;}' /var/log/pacman.log | awk '{print $1}')

(
	echo "System Information" # Fist line goes to title
	# The following lines go to slave window
	echo "Host: $HOST "
	echo "User: $USER "
	echo "Kernel: $KERNEL"
	echo "Pacman: $PACKAGES packages"
	echo "Last updated on: $UPDATED"
	sleep $T
) | dzen2 -xs 3 -bg $BG -fg $FG -fn $FONT -x $xaxis -y '13' -w "200" -l "5" -sa 'l' -ta 'c' -title-name 'popup_sysinfo' -e 'onstart=uncollapse;button1=exit;button3=exit'

sleep 5
exit

# "onstart=uncollapse" ensures that slave window is visible from start.
