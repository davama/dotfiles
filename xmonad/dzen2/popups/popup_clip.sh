#!/bin/bash

trap 'rm clip.* 2> /dev/null' EXIT

source ~/.xmonad/dzen2/source-config.sh
WIDTH="500"
LINES="5"
color="#87afd7"
PX=$(xdotool getmouselocation | awk '{print $1}' | cut -d':' -f2)
OPTIONS="entertitle=uncollapse,grabkeys;button1=exit;button3=exit"
PX1=$(($PX - 190))

xclip -selection primary -o > clip.p
xclip -selection clipboard -o >> clip.c

diff clip.c clip.p &> /dev/null

if [ $? -eq 0 ]; then	# both the same
	echo "################### X Clipboard: ###################" > clip.f
	echo -e "\n" >> clip.f
	xclip -selection primary -o >> clip.f
else	# different
	echo "################### X Clipboard: ###################" > clip.f
	echo -e "\n" >> clip.f
	xclip -selection primary -o >> clip.f
	echo -e "\n\n" >> clip.f
	echo "################### Desktop Clipboard: ###################" >> clip.f
	echo -e "\n" >> clip.f
	xclip -selection clipboard -o >> clip.f
fi

mpclines=$(cat clip | wc -l)

gxmessage -geometry 800x600 -file clip.f
