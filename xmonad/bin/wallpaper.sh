#!/bin/bash

# Copyright (c) 2011 Josh Schreuder
# http://www.postteenageliving.com

PID=$$
ps aux | grep wallpaper | grep -v grep | awk '{print $2}' | grep -v $PID | xargs kill 

ACTIVEMONITORS=`cat /tmp/active_monitors`

#################################################
# Search through Single directory to randomized images on screen(s)
#################################################
function single_images () {
	background1=$(find ~/.xmonad/Pictures/Single -maxdepth 1 -type f \( -name '*.jpg' -o -name '*.png' \) -print0 | shuf -n1 -z)
	background2=$(find ~/.xmonad/Pictures/Single -maxdepth 1 -type f \( -name '*.jpg' -o -name '*.png' \) -print0 | shuf -n1 -z)
	while [ $background1 == $background2 ]; do
		background1=$(find ~/.xmonad/Pictures/Single -maxdepth 1 -type f \( -name '*.jpg' -o -name '*.png' \) -print0 | shuf -n1 -z)
		background2=$(find ~/.xmonad/Pictures/Single -maxdepth 1 -type f \( -name '*.jpg' -o -name '*.png' \) -print0 | shuf -n1 -z)
	done
	#feh --bg-max $background1 $background2
	feh --bg-scale $background1 $background2
	sleep 1m
}

#################################################
# Search through Dual directory for dual monitor images 
#################################################
function dual_monitor_images () {
	# No xinerama wallpaper
	screen=$(find ~/.xmonad/Pictures/Dual -maxdepth 1 -type f \( -name '*.jpg' -o -name '*.png' \) -print0 | shuf -n1 -z)
	feh --bg-scale --no-xinerama $screen
	sleep 1m
}

#################################################
# Similar to above one but using 2 images to make one image
#################################################
function single_but_dual_images () {
	if [ $ACTIVEMONITORS -eq 2 ]; then
		background_name=$(find ~/.xmonad/Pictures/Dual/Left -maxdepth 1 -type f \( -name '*.jpg' -o -name '*.png' \) -print0 | shuf -n1 -z | cut -d'-' -f1 | sed 's|/| |g' | awk '{print $NF}')
		background1=$(find ~/.xmonad/Pictures/Dual/Left/$background_name* -maxdepth 1 -type f \( -name '*.jpg' -o -name '*.png' \) -print0 | shuf -n1 -z)
		background2=$(find ~/.xmonad/Pictures/Dual/Right/$background_name* -maxdepth 1 -type f \( -name '*.jpg' -o -name '*.png' \) -print0 | shuf -n1 -z)
		feh --bg-scale $background1 $background2
		sleep 1m
	fi
}

function APOD_images () {

#################################################
### APOD ###
#################################################
# ********************************
# *** OPTIONS
# ********************************
# Set this to 'yes' to save a description (to ~/description.txt) from APOD page
GET_DESCRIPTION="no"
# Set this to the directory you want pictures saved
PICTURES_DIR=~/Pictures/APOD
# Set this to the directory you want description saved
DESCRIPTION_DIR=~/Pictures/APOD
mkdir -p $PICTURES_DIR
 
# ********************************
# *** FUNCTIONS
# ********************************
function get_page {
	echo "Downloading page to find image"
	wget http://apod.nasa.gov/apod/ --quiet -O /tmp/apod.html
	grep -m 1 jpg /tmp/apod.html | sed -e 's/<//' -e 's/>//' -e 's/.*=//' -e 's/"//g' -e 's/^/http:\/\/apod.nasa.gov\/apod\//' > /tmp/pic_url
}

function clean_up {
	# Clean up
	echo "Cleaning up temporary files"
	if [ -e "/tmp/pic_url" ]; then
		rm /tmp/pic_url
	fi
 
	if [ -e "/tmp/apod.html" ]; then
		rm /tmp/apod.html
	fi
}
 
# ********************************
# *** MAIN
# ********************************
echo "===================="
echo "== APOD Wallpaper =="
echo "===================="
# Set date
TODAY=$(date +'%Y%m%d')
 
# If we don't have the image already today
if [ ! -e ~/Pictures/APOD/${TODAY}_apod.jpg ]; then
	echo "We don't have the picture saved, save it"
 
	get_page
 
	# Got the link to the image
	PICURL=`/bin/cat /tmp/pic_url`
 
	echo  "Picture URL is: ${PICURL}"
 
	echo  "Downloading image"
	wget --quiet $PICURL -O $PICTURES_DIR/${TODAY}_apod.jpg
  
	echo "Setting image as wallpaper"
	feh --bg-scale $PICTURES_DIR/${TODAY}_apod.jpg
 
# Else if we have it already, check if it's the most updated copy
else
	get_page
 
	# Got the link to the image
	PICURL=`/bin/cat /tmp/pic_url`
 
	echo  "Picture URL is: ${PICURL}"
 
	# Get the filesize
	SITEFILESIZE=$(wget --spider $PICURL 2>&1 | grep Length | awk '{print $2}')
	FILEFILESIZE=$(stat -c %s $PICTURES_DIR/${TODAY}_apod.jpg)
 
	# If the picture has been updated
	if [ $SITEFILESIZE != $FILEFILESIZE ]; then
		echo "The picture has been updated, getting updated copy"
		rm $PICTURES_DIR/${TODAY}_apod.jpg
 
		# Got the link to the image
		PICURL=`/bin/cat /tmp/pic_url`
 
		echo  "Downloading image"
		wget --quiet $PICURL -O $PICTURES_DIR/${TODAY}_apod.jpg
 
		   echo "Setting image as wallpaper"
		feh --bg-scale $PICTURES_DIR/${TODAY}_apod.jpg
 
	# If the picture is the same
	else
		echo "Picture is the same, finishing up"
		echo "Setting image as wallpaper"
		feh --bg-scale $PICTURES_DIR/${TODAY}_apod.jpg
	fi
fi
clean_up
sleep 1m
}

# infinte loop to loop through images
while true; do
	# loop through itself; get all function names
	#for i in $(grep function ~/.xmonad/bin/wallpaper.sh | grep -v get_page | grep -v clean_up | awk '{print $2}' | shuf -n1 | grep APOD); do
	for i in $(grep function ~/.xmonad/bin/wallpaper.sh | grep -v get_page | grep -v clean_up | awk '{print $2}' | shuf -n1); do
		if [ $i == "$(cat /tmp/last_wallpaper_function)" ]; then
			continue
		fi
		$i
		echo $i > /tmp/last_wallpaper_function
	done
done
