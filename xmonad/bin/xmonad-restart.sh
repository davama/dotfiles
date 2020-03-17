#!/bin/bash -

# replace basic mod-q with this script
# kills several processes and restart xmonad if it compiles properly

trap 'rm /tmp/*-$$ 2> /dev/null' EXIT

# clear any existing urgents; xmonad key combo
#xdotool key super+shift+BackSpace
sleep 1
echo "Windowmanager restarting..." | osd_cat --font 9x15bold --delay 2 --outline 3 --colour gray -p middle -A center &
xmonad --recompile &>/tmp/output-restart-$$
SIG=$?
pkill xmessage
pkill xmessage
sleep 1
pkill xmessage

if grep ".*rror\ detected\ while\ loading\ xmonad\ configuration\ file:\.*xmonad/xmonad.hs.*" /tmp/output-restart-$$ || [ $SIG -eq 1 ]; then
	cat /tmp/output-restart-$$ | gxmessage -geometry 800x500 -file -
	exit 1
fi

pkill dzen2
pkill xmobar
#pkill mpd
pkill wallpaper.sh
pkill xautolock
pkill udiskie
pkill compton
pkill xplanet
pkill conky
pkill unclutter
ps aux | grep ssh_connections.sh | grep -v grep | awk '{print $2}' | xargs kill


#exit

for i in $(ps aux | grep dzen | grep -v grep | awk '{print $2}'); do
	kill $i
done

chmod +x ~/.xmonad/xmonad-x86_64-linux
xmonad --restart
echo "Windowmanager restarted" | osd_cat --font 9x15bold --delay 2 --outline 3 --colour green -p middle  -A center &
