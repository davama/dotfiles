#!/bin/sh

USER=dmacias

# Kills all your processes when you log out.
ps --user $USER | awk 'NR > 1 {print $1}' | xargs -t kill

# Sets the desktop background to solid black. Useful if you have multiple monitors.
xsetroot -solid black
pkill xmobar
pkill mpd
pkill ncmpcpp
pkill wallpaper.sh
pkill screensaver
pkill udiskie
pkill unclutter
ps aux | grep ssh_connections.sh | grep -v grep | awk '{print $2}' | xargs kill


for i in $(ps aux | grep dzen | grep -v grep | awk '{print $2}'); do
	kill $i
done

pkill xmonad

# Terminate current user session
/usr/bin/loginctl terminate-session \$XDG_SESSION_ID

# Restart lxdm
sudo /usr/bin/systemctl restart lightdm

