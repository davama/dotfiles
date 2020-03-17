#!/bin/bash

# small zenity USB unmount script

trap 'rm /tmp/*-$$ 2> /dev/null' EXIT

exec 2> /dev/null	# dumb me couldn't fix the zenity output error

# count of USBs in 'media' directory if any
count=$(df | grep media | wc -l)

if [ $count -eq 0 ]; then exit 0; fi	# exit if 0

# output name of devices pluged in
df | grep media | cut -f 5- -d'/' > /tmp/umount-out-$$

# if more than 1 then inputs the word "ALL" to the first line in file
if [ $count -gt 1 ]; then
	sed -i '1iALL\' /tmp/umount-out-$$
	#sed -i '1iNULL\' ~/.xmonad/bin/out
fi

# zenity script; waits for answer
USB=$(cat /tmp/umount-out-$$ | zenity --list --title "Unmount USB w/ Zenity" --column "Pick one")
# if no answer exits
if [ -z "$USB" ]; then 	exit 0; fi

# if answer was "ALL" then 
if [ $USB = ALL ]; then 
	for u in $(cat /tmp/umount-out-$$); do
		i=1
	#	df | grep media | sed -n "${i}{p;q;}" | awk '{print $1}'
		umount $(df | grep media | sed -n "${i}{p;q;}" | awk '{print $1}')
		if [ i -eq 3 ]; then continue; fi
		i=`expr + 1`
	done
	exit
else
	USB=$(echo $USB | sed 's/ /\ /g')
	df | grep "$USB" | awk '{print $1}'
	umount $(df | grep "$USB" | awk '{print $1}')
fi
