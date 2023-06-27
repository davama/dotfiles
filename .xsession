#!/bin/bash

# setup display 
~/.screenlayout/archlab-arandr-extend-display.sh

# enable numlock
numlockx &

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
#pkill picom
picom -c --active-opacity 4.0 --shadow-ignore-shaped &

# logitech trachball mouse
solaar -w hide &

# background scrpts

# for conky/dzen2 label
#~/.xmonad/bin/ssh_connections.sh &

~/.xmonad/bin/get-installed-packages.sh &
#~/.xmonad/bin/xmonad-backup-sandbox.sh &

# set background color
#hsetroot -solid "#0e2f44"

# set background image
feh --bg-scale Google-Drive/Linux/manjaro/NuFVbLW.jpg

# flameshot
flameshot &
