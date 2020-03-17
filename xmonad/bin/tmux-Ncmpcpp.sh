#!/bin/bash

#################################################################################
## this is example configuration file, copy it to                              ##
## ~/.ncmpcpp/ncmpcpp_tmux and set up preferences                              ##
## Author : Nietz Hyeon                                                        ##
## ncmpcpp-tmux session : https://bbs.archlinux.org/viewtopic.php?id=94969&p=7 ##
## Screenshot : http://i.imgur.com/KorgvcL.png                                 ##
#################################################################################

# Switch between panes use CTRL+b o
# to load a particular playlist run:
# mcp clear
# mpc load <playlist>
# mpc play

pkill mpd
pkill ncmpcpp
sleep 1
mpd

#if ! [ -z "$1" ]; then
#	exit
#fi
TERMINAL=$1
SESSION=ncmpcpp

# Specify the startup/slave screen (<name> may be: help, playlist, browser, search-engine, media-library, playlist-editor, tag-editor, outputs, visualizer, clock)
$TERMINAL -T scratchpadmpd -e "tmux -2 new-session -s $SESSION 'ncmpcpp -c ~/.ncmpcpp/config-top -s help -S clock'" # top-pane
$TERMINAL -T scratchpadmpd -e "tmux -2 split-window -t $SESSION:0 -p 70 'ncmpcpp -c ~/.ncmpcpp/config-mid -s visualizer -S outputs'" # mid-pane
$TERMINAL -T scratchpadmpd -e "tmux -2 split-window -t $SESSION:0 -p 50 'ncmpcpp -c ~/.ncmpcpp/config-btm -s playlist -S media_library'" #btm-pane

# removes title "top" section from middle and bottom
tmux -2 send-keys -t $SESSION:0.1 '\'
sleep 1
tmux -2 send-keys -t $SESSION:0.2 '\'

# Bottom's status bar off : tmux 상태바 끄기
tmux -2 set -t $SESSION -g status off
####tmux -2 attach-session -t $SESSION:0.2
