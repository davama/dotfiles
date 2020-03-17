#!/bin/bash

# rebuild ga-cmd code using new secret

cd ~/

rm -rf ~/ga-cmd

git clone https://github.com/arcanericky/ga-cmd.git
wait
sed -i '/url =/d' ~/ga-cmd/.gitmodules
echo -e "\turl = https://github.com/google/google-authenticator.git" >> ~/ga-cmd/.gitmodules
cd ~/ga-cmd/
git submodule init
wait
git submodule update
wait
cd ~/ga-cmd/src
# $1 is the 16 digit seed
~/ga-cmd/src/build.sh $1

echo
# can verify using official google auth app
~/ga-cmd/src/bin/ga-cmd
