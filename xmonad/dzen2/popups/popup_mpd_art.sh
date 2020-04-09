#!/bin/bash

# taken from: http://lmazy.verrech.net/2011/01/cover-art-with-conky-and-mpd/

# need to install python-eyed3
IFS=$'\t' mpd_array=( $(MPD_HOST=localhost MPD_PORT=6600 \
          mpc --format "\t%artist%\t%album%\t%file%\t") );

mkdir -p /tmp/mpd
filename="conky_cover.png";
placeholder="/tmp/mpd/placeholder.png"

# extract image from mp3 file and saves as other
if [[ ! -f /tmp/"${mpd_array[1]}".album ]] ; then
#if [[ -f /tmp/"${mpd_array[1]}".album ]] ; then
	rm -f /tmp/*.album &> /dev/null
	eyeD3 --write-images=/tmp/mpd $HOME/Music/${mpd_array[2]} &> /dev/null
	touch /tmp/${mpd_array[1]}.album
	album=`dirname "/tmp/mpd"`;
	cover=`ls -t /tmp/mpd/* | egrep -i "jpeg|jpg|png|gif" | head -n 1`;
	ls -t /tmp/mpd/* | sed -n '1!p' | xargs rm -f -
	if [[ ! -f $cover ]]; then
		cp $cover /tmp/$filename;
	else
		convert $cover -resize "130>x" -alpha On -channel A -evaluate set 25% /tmp/$filename;
	fi
fi
