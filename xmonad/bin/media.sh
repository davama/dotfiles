#!/bin/bash

# shows all mounted devices

#media=$(df -h | grep media |  grep -Pzo ' /media(.*\n)*' | cut -d'/' -f3 | sed 's/$/ | /g')
media=$(df -h | grep media |  sed -e 's|^.*/media/||g' | sed 's/$/ | /g' | sed ':a;N;$!ba;s/\n//g')
if ! [[ -z $media ]]; then
	echo $media
fi
