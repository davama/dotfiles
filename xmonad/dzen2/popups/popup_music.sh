#!/bin/bash

trap 'rm /tmp/selection.txt 2> /dev/null' EXIT

source ~/.xmonad/dzen2/source-config.sh
WIDTH="500"
LINES="5"
color="#87afd7"
PX=$(xdotool getmouselocation | awk '{print $1}' | cut -d':' -f2)
# lines for playlist 
#mpclines=$(mpc playlist -f "[%id% %artist% - %title%]" | wc -l)
mpclines=40	# playlist got too long so made it static, had to add scroll ability
# options for first dzen
FOPTIONS="onstart=uncollapse,hide;button1=exit;button3=exit"	
# options for second
SOPTIONS="entertitle=uncollapse,grabkeys;button1=exit;button4=scrollup;button5=scrolldown;button3=exit"
PX1=$(($PX - 190))

mpc &> /dev/null
if [ $? -eq 1 ]; then
	exit
fi

function dzen_playlist () {
# first is the media buttons
(echo "       "; echo "        "; echo "   ^ca(1, mpc prev)  ^fg($color)^i($HOME/.xmonad/dzen2/icons/prev.xbm) ^ca()    ^ca(1, mpc pause) ^i($HOME/.xmonad/dzen2/icons/pause.xbm) ^ca()    ^ca(1, mpc play) ^i($HOME/.xmonad/dzen2/icons/play.xbm) ^ca()    ^ca(1, mpc next) ^i($HOME/.xmonad/dzen2/icons/next.xbm) ^ca()"; echo " "; echo "   ^ca(1, mpc repeat on)^ca(3, mpc repeat off)  ^fg($color)^i($HOME/.xmonad/dzen2/icons/repeat.xbm) ^ca()^ca()          ^ca(1, mpc random on)^ca(3, mpc random off)  ^i($HOME/.xmonad/dzen2/icons/random.xbm) ^ca()^ca() "; echo " "; sleep 3) | dzen2 -fg $FG -bg $BG -fn $FONT -x $PX1 -y '13' -w "190" -l $LINES -e $FOPTIONS &

# second is the mpc playlist /tmp/selection.txt
(echo "Playlist"; echo "$(mpc playlist -f "[%id% - %artist%   -   %title%]")" | tac - | sed "s|'||g; s|)||g; s|(||g"; sleep 10) | dzen2 -fg $FG -bg $BG -fn $FONT -x $PX -y '14' -w $WIDTH -l $mpclines -m v -e $SOPTIONS &> /tmp/selection.txt

#debug playlist mouse click output
#cat /tmp/selection.txt

if grep -q bash /tmp/selection.txt; then
mpc play $(grep "command not found" /tmp/selection.txt | head -1 | cut -d':' -f2)
fi
}

function zenity_playlist () {
	SONGS=$(mpc playlist -f "[%id% - %artist%   -   %title%]" | zenity --list --title "Current MPD Playlist" --column "Pick one" --print-column=ALL --width=500 --height=500)
	if [ -z "$SONGS" ]; then	exit 0; fi # if no answer exits
	if [ $(echo $SONGS | awk '{print $1}') -gt 0 ]; then
		mpc play $(echo $SONGS | awk '{print $1}')
	fi
}

function zenity_lsplaylist () {
	PLAYLIST=$(mpc lsplaylist | zenity --list --title "Select Playlist" --column "Pick one" --print-column=ALL --width=500 --height=500)
	if [ -z "$PLAYLIST" ]; then
		exit 0
	else
		mpc clear
		# interstingly clearing and loading playlist does not rest the playlist track# (positions). So if clear load a playlist of 20, twice, i will have a the same playlist of 20 songs but from position 20 through 40
		# so killing mpd and restarting after a clear
		pkill mpd && mpd
		mpc load $(echo $PLAYLIST | awk '{print $1}')
		mpc play
	fi
}

case $1 in
	1)	zenity_playlist;;
	2)	zenity_lsplaylist;;
	*)	echo Error; exit;;
esac
