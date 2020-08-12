#!/bin/bash
# https://github.com/davama

shopt -s extglob
cd ~/GITREPO/dotfiles/
rm !(README.txt) -rf
rm -Rf ~/GITREPO/dotfiles/*

mkdir -p ~/GITREPO/dotfiles/xmonad/dzen2
mkdir -p ~/GITREPO/dotfiles/xmonad/bin
mkdir -p ~/GITREPO/dotfiles/xmonad/conky
mkdir -p ~/GITREPO/dotfiles/.mpd
mkdir -p ~/GITREPO/dotfiles/.ncmpcpp
mkdir -p ~/GITREPO/dotfiles/xplanet
mkdir -p ~/GITREPO/dotfiles/dmz

# https://github.com/davama/dotfiles
cp ~/.xmonad/xmonad.hs ~/GITREPO/dotfiles/xmonad/
cp ~/.xmonad/stack.yaml ~/GITREPO/dotfiles/xmonad/
cp ~/.xmonad/build ~/GITREPO/dotfiles/xmonad/
cp ~/.xmonad/help_* ~/GITREPO/dotfiles/xmonad/
cp -r ~/.xmonad/dzen2/* ~/GITREPO/dotfiles/xmonad/dzen2/
cp -r ~/.xmonad/bin/*.sh ~/GITREPO/dotfiles/xmonad/bin/
cp -r ~/.config/conky/* ~/GITREPO/dotfiles/xmonad/conky/
cp -r ~/.xmonad/icons ~/GITREPO/dotfiles/xmonad/
cp -r ~/.xplanet/* ~/GITREPO/dotfiles/xplanet/
cp -r ~/dmz/* ~/GITREPO/dotfiles/dmz/

# dotfiles git repo
# https://github.com/davama/dotfiles
cp ~/.bashrc ~/GITREPO/dotfiles/
sed -i "s/alias grive='grive --id.*/alias grive='grive --id <redacted> --secret <redacted>'/g" ~/GITREPO/dotfiles/.bashrc
for i in 1 2 3 4 5 9; do
	sed -i "s/export MAIL_ACCOUNT_$i=.*/export MAIL_ACCOUNT_$i=<redacted>@<email.com>/g" ~/GITREPO/dotfiles/.bashrc
done
cp ~/.urlview ~/GITREPO/dotfiles/
cp ~/.mailcap ~/GITREPO/dotfiles/
cp ~/.muttrc ~/GITREPO/dotfiles/
cp ~/.mutt_colorc ~/GITREPO/dotfiles/
cp ~/.mutt_accountsrc ~/GITREPO/dotfiles/
#cp  ~/.mutt/*gmail* ~/GITREPO/dotfiles/.mutt/
#for i in $(ls GITREPO/dotfiles/.mutt/*@*); do 
#	sed -i 's/^set from =.*/set from = "<redacted>"/g' $i
#	sed -i 's|^set smtp_url =.*|set smtp_url = "smtps://<redacted>@smtp.gmail.com/"|g' $i
#	sed -i 's/^set smtp_pass =.*/set smtp_pass = "<redacted>"/g' $i
#	sed -i 's/^set imap_user =.*/set imap_user = "<redacted>"/g' $i
#	sed -i 's/^set imap_pass =.*/set imap_pass = "<redacted>"/g' $i
#done
cp ~/.mpd/mpd.conf ~/GITREPO/dotfiles/.mpd/
cp ~/.ncmpcpp/config ~/GITREPO/dotfiles/.ncmpcpp/
cp ~/.ncmpcpp/config-top ~/GITREPO/dotfiles/.ncmpcpp/
cp ~/.ncmpcpp/config-mid ~/GITREPO/dotfiles/.ncmpcpp/
cp ~/.ncmpcpp/config-btm ~/GITREPO/dotfiles/.ncmpcpp/
cp ~/.Xdefaults ~/GITREPO/dotfiles/
cp ~/.asoundrc ~/GITREPO/dotfiles/
cp ~/.vimrc ~/GITREPO/dotfiles/
cp ~/.xsession ~/GITREPO/dotfiles/
 
if [ -z $1 ]; then
	DIR=".git"
else
	exit
fi

for d in $(ls -d ~/GITREPO/*); do
	cd $d
	gitrepo=$(echo $d | cut -d'/' -f5)
	if [ -d "$DIR" ]; then
		read -p "$gitrepo Commit Reason? " reason
		git add .
		git commit -m "$reason"
		git push origin master
	else
		git init
		git add .
		git commit -m 'First commit'
		git remote add origin git@github.com:davama/xmonad.git
		git remote -v
		git push origin master
	fi
done

# having issues try
# git push origin master --force

### if forking
## clone the fork
# git clone https://githum.com/davama/myfork/
# cd myfork
## add upstream alias to original repo
# git remote add upstream https://github.com/<maintainer>/<myfork-repo>/
## see remotes
# git remote -v
## fetch updates from upstream
# git fetch upstream
# git rebase upstream/master
## commit
# git add .
# git commit -m "reason for commit"
## set remote url for origin alias
# git remote set-url origin git@github.com:davama/myfork
## push changes
# git push
