#!/bin/bash

# to allow me to turn on off 
# using the same kebinding in xmonad

if ps ux | grep -v grep | grep -q conky_mpd_art; then
	ps ux | grep -v grep | grep conky_mpd_art | awk '{print $2}' | xargs kill
	exit
fi

conky -c ~/.xmonad/dzen2/conky_mpd_art
