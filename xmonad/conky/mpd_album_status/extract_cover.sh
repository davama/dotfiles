#!/bin/bash

# requires perl-image-exiftool

MPD_MUSIC_PATH="/home/dvmacias/Music"
TMP_COVER_PATH="/tmp/mpd-track-cover"
COVER_PATH="/tmp/mpd-track-cover.png"

exiftool -b -Picture "$MPD_MUSIC_PATH/$(mpc --format "%file%" current)" > "$TMP_COVER_PATH"
convert $TMP_COVER_PATH $COVER_PATH
