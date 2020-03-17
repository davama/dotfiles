#!/bin/bash

# small script which opens xmonad and dzen configs depending on the 1st paramater.
# will not work if using dzen

if [ -z $1 ]; then
	exit 1
fi

function F11 () {
	if ps aux | grep vim | grep -E "xmonad.hs"; then
		exit 1
	else
		vim ~/.xmonad/xmonad.hs
	fi
	return
}

function F10 () {
	if ps aux | grep vim | grep -E "conkydzen1"; then
		exit 1
	fi
	if [ $(ps aux | grep dzen | wc -l) -gt 1 ]; then
		vim $(ps aux | grep conky | grep -v grep | grep -v vim | awk '{print $NF}' | head -1)
		return 0
	fi
}

function F9 () {
	if ps aux | grep vim | grep -E "conkydzen2"; then
		exit 1
	fi
	if [ $(ps aux | grep dzen | wc -l) -gt 1 ]; then
		vim $(ps aux | grep conky | grep -v grep | grep -v vim | awk '{print $NF}' | tail -1)
		return 0
	fi
}

case $1 in
	"F11")  F11;;
	"F10")	F10;;
	"F9")	F9;;
	*)	exit 1
esac
