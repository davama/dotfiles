#!/bin/bash

# Command-line world clock

trap 'rm /tmp/*-$$ 2> /dev/null' EXIT

cat >/tmp/timezones-$$ <<EOF
UTC
US/Eastern
Europe/London
Europe/Paris
Asia/Kolkatta
Africa/Johannesburg
Asia/Tokyo
Asia/Shanghai
EOF

while true; do 
#	tput clear
	echo -e '\0033\0143'
#	printf '\033\143'
	while read zone; do 
		echo -e "\t"'!' $zone '!'
		TZ=$zone date +"%H-%m-%S" | figlet -f script
	done < /tmp/timezones-$$
	sleep 1
done
