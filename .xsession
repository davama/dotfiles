#!/bin/bash


# makes cursor disappeare
pkill unclutter
unclutter -idle 3 -root & 

# my screensaver
pkill xautolock
xautolock -detectsleep -time 5 -locker '~/.xmonad/bin/my-hacky-screensaver.sh &> /tmp/failed.txt' &

# usb automounting
pkill udiskie
/usr/bin/udiskie -q -N -a -t & 

# turn on transparency
pkill compton
compton -CG --active-opacity 4.0 --shadow-ignore-shaped &

# background scrpts

# for conky/dzen2 label
~/.xmonad/bin/ssh_connections.sh &

~/.xmonad/bin/get-installed-packages.sh &
#~/.xmonad/bin/xmonad-backup-sandbox.sh &

