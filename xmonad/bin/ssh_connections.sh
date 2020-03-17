#!/bin/bash

# loop for ssh connection; if not then delete file

OUTPUTFILE=/tmp/ssh-remote.txt


while true; do
	if ps aux | grep 2222  | grep -q ssh; then
		:
	else
		cat /dev/null > $OUTPUTFILE
	fi
		sleep 3
done
