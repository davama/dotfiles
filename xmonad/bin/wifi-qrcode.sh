#!/bin/bash

weth="wifi0"
essid=$(iwconfig $weth | head -1 | awk '{ print $NF}' | cut -d':' -f2 | sed 's/"//g')
essid_profile=$(ls /etc/netctl/$(echo $essid | tr '[:upper:]' '[:lower:]').p)
secret=$(cat $essid_profile | grep -E "Key=|password=" | cut -d= -f2 | sed "s/'//g; s/\"//g")
qrencode -o - -t utf8 "WIFI:S:$essid;T:WPA;P:$secret;;"
sleep 3
