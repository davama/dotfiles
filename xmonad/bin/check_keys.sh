#!/bin/sh

# see if num lock; caps lock are on
# see if something is in clipboard

trap 'rm /tmp/*-$$ 2> /dev/null' EXIT

mask=$(xset q | grep LED | awk '{print $NF}')

if [ $mask == '00000000' ]; then
    capslock=""
    numlock=""
elif [ $mask == '00000001' ]; then
    capslock="CAPS"
    numlock=""
elif [ $mask == '00000002' ]; then
    capslock=""
    numlock="NUM"
elif [ $mask == '00000003' ]; then
    capslock="CAPS"
    numlock="NUM"
fi

# place xclipboard and CLIPBOARD into file; used in dzen
xclip -selection primary -o &> /dev/null && xclip -selection primary -o > /tmp/clip-output-$$
xclip -selection clipboard -o &> /dev/null && xclip -selection clipboard -o >> /tmp/clip-output-$$


if [[ -s /tmp/clip-output-$$ ]]; then
	clip="CLIP"
else
	clip=""
fi


echo $capslock $numlock $clip
