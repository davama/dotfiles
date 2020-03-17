#!/bin/bash

trap 'rm /tmp/choose_color.txt' EXIT

# simple one color background

pkill wallpaper.sh
pkill xplanet

### normally from xmonad process ###

if [ $# -eq 1 ]; then
	if [[ $1 == "#"* ]] ; then
		hsetroot -solid $1
	else
		feh --bg-scale $1
	fi
	exit
elif [ $# -eq 2 ]; then
	if [[ $1 == "#"* ]] ; then
		hsetroot -solid $1
	else
		feh --bg-scale $1 $2
	fi
	exit
fi

### if running from terminal with no arguments ###

# fromhex A52A2A
# fromhex "#A52A2A"
# BLUE_VIOLET=$(fromhex "#8A2BE2")
# http://unix.stackexchange.com/a/269085/67282
function fromhex() {
	if [[ $hex == "#"* ]]; then
		hex=$(echo $1 | awk '{print substr($0,2)}')
	fi
	r=$(printf '0x%0.2s' "$hex")
	g=$(printf '0x%0.2s' ${hex#??})
	b=$(printf '0x%0.2s' ${hex#????})
	color_256=$(echo -e `printf "%03d" "$(((r<75?0:(r-35)/40)*6*6+(g<75?0:(g-35)/40)*6+(b<75?0:(b-35)/40)+16))"`)
}

function echo_color_to_term () {
	echo -e "\e[48;5;${color_256}m ${color_name_input} \e[0m ; Color: $color_name ; Hexcode: $hex ; 256code: $color_256"
}

# dynamically set color based of what is already configured in xmonad.hs
grep "data Colors" ~/.xmonad/xmonad.hs | cut -d'=' -f2 | sed 's/|//g'
read -p "Please type the color name: " color_name_input
if grep -i "$color_name_input" ~/.xmonad/xmonad.hs | grep "#" | grep ")) " | sed 's/--.*//g' | awk '{print $(NF-1),$NF}' | cut -d'"' -f2,4 | sed 's/"/\n/g' | grep -q "#"; then
	for i in $(grep -i "$color_name_input" ~/.xmonad/xmonad.hs | grep "#" | grep ")) " | sed 's/--.*//g' | awk '{print $(NF-1),$NF}' | cut -d'"' -f2,4 | sed 's/"/\n/g') ; do
		color_name=$(grep -i "$color_name_input" ~/.xmonad/xmonad.hs | grep "#" | grep ")) " | sed 's/--.*//g' | awk '{print $2}' | cut -d'(' -f2)
		hex=$i
		fromhex "$i"
		echo_color_to_term
		echo $hex >> /tmp/choose_color.txt
	done
fi

while true; do
	cat -n /tmp/choose_color.txt
	read -p "Please choose which $color_name you like. Type 1 or 2: " number_choice_input
	case $number_choice_input in
		1)	final_color=$(head -1 /tmp/choose_color.txt); break;;
		2)	final_color=$(tail -1 /tmp/choose_color.txt); break;;
		*)	echo Try again...; echo;;
	esac
done

hsetroot -solid "#$final_color"
