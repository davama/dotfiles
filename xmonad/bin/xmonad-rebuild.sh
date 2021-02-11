#!/bin/bash

function remove_ghc_files () {
	rm -r ~/.stack
}
function remove_local_files () {
	rm -r ~/.xmonad/.stack-work ~/.xmonad/stack.yaml
}
function recreate_local_files () {
	cp -r ~/.stack-backup ~/.stack
	cp -r ~/.xmonad/.stack-work-backup ~/.xmonad/.stack-work
	cp -r ~/.xmonad/stack.yaml-backup ~/.xmonad/stack.yaml
}
function delete_backups () {
	rm -r ~/.stack-backup ~/.stack-work-backup ~/.xmonad/.stack-work-backup
}
function build_failed () {
	remove_ghc_files 2> /dev/null
	remove_local_files 2> /dev/null
	recreate_local_files
	delete_backups 2> /dev/null
	echo -e "\n\nXmonad rebuilt has FAILED"
	exit
}
function update_git () {
	cd ~/xmonad-git
	for i in $(ls); do 
		cd ~/xmonad-git/$i
		pwd
		#git pull
		echo; cd ~/xmonad-git
	done
}
function rebuild_xmonad () {
	cd ~/.xmonad
	stack init || build_failed # if stack.yml already exist then `solver`
	#stack solver || build_failed
	stack install || build_failed
}
function rebuild_ghc () {
	# start building from stack; new sandbox
	#stack setup || build_failed
	# NOTE: For idea which ghc version to use, see <package>.cabal file
	#      grep tested-with ~/.xmonad/xmonad-git/xmonad*/xmonad*.cabal
	#      stack ghc -- --version # see current ghc version stack is using
	#stack --resolver ghc-8.6.5 setup || build_failed
	#stack --resolver ghc-8.8.4 setup || build_failed
	stack --resolver ghc-8.10.3 setup || build_failed
}

cd
echo Updating Git Repos...
update_git
remove_local_files 2> /dev/null

# if provide argument
if [ -z $1 ]; then
	echo -e "\n################### Rebuilding Xmonad... ########################\n"
	rebuild_xmonad
else
	remove_ghc_files 2> /dev/null
	echo -e "\n################### Rebuilding GHC... ########################\n"
	rebuild_ghc
	echo -e "\n################### Rebuilding Xmonad... ########################\n"
	rebuild_xmonad
	rebuild_xmonad
fi

echo -e "\n################### Xmonad has successfully rebuilt ########################\n"
