#!/bin/sh
#AccuWeather (r) RSS weather tool for conky
#
#USAGE: weather.sh <locationcode>
#
#(c) Michael Seiler 2007

METRIC=0 #Should be 0 or 1; 0 for F, 1 for C
LOCCOD=""  # Example: OCN|AU|VIC|MELBOURNE

if [ -z $1 ] && [ -x $LOCCOD ] ; then
        echo
        echo "USAGE: $0 [locationcode]"
        echo
        exit 0;
elif [ ! -z $1 ] ; then
        LOCCOD=$1
fi

curl -s http://rss.accuweather.com/rss/liveweather_rss.asp\?metric\=${METRIC}\&locCode\=$LOCCOD | perl -ne 'if (/Currently/) {chomp;/\<title\>Currently: (.*)?\<\/title\>/; print "$1"; }'
