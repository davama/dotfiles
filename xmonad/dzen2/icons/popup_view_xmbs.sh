#!/bin/bash

trap 'rm xbmfile xbmscript.sh 2> /dev/null' EXIT

source ~/.xmonad/dzen2/config.sh
WIDTH="500"
LINES="40"
color="#87afd7"
PX=$(xdotool getmouselocation | awk '{print $1}' | cut -d':' -f2)
# lines for playlist 
#mpclines=$(mpc playlist -f "[%id% %artist% - %title%]" | wc -l)
mpclines=40	# playlist got too long so made it static, had to add scroll ability
# options for first dzen
FOPTIONS="onstart=uncollapse,hide;button1=exit;button3=exit"	
# options for second
SOPTIONS="entertitle=uncollapse,grabkeys;button1=exit;button4=scrollup;button5=scrolldown;button3=exit"
SOPTIONS="onstart=uncollapse,grabkeys;button1=exit;button4=scrollup;button5=scrolldown;button3=exit"
PX1=$(($PX - 190))


echo "(echo \"      \";" > xbmfile

for i in $(ls ~/.xmonad/dzen2/icons/*.xbm); do 
	name=$(echo $i | sed 's|/| |g' | awk '{print $NF}')
	echo "echo \"  ^fg(#87afd7)^i($i) \"$name\"\";" >> xbmfile
done
echo " sleep 60)" >> xbmfile


sed ':a;N;$!ba;s/\n/ /g' xbmfile > xbmscript.sh

chmod +x xbmscript.sh
./xbmscript.sh | dzen2 -fg $FG -bg $BG -fn $FONT -x $PX1 -y '13' -w "190" -l $LINES -e $SOPTIONS &
