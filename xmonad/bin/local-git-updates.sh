#!/bin/bash 

# running cgit with nginx/fcgiwrap locally 
# helps me keep track of my google-drive changes
# since dont publish them on github


cd ~/Google-Drive
git add --all .
git commit --quiet -m "Google-Drive Updates"


cd ~/Personal-Google-Drive
git add --all .
git commit --quiet -m "Personal-Google-Drive Updates"
