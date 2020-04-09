#!/bin/bash

date=$(date '+%Y%m%d-%H%M%S')

trap 'rm -rf ~/.sandbox-backup-delta/$date 2> /dev/null' EXIT

rm -rf ~/.sandbox-backup-delta/*

function create_backups () {
	mkdir -p ~/.sandbox-backup-delta/$date
	cp -r ~/.stack ~/.sandbox-backup-delta/$date/stack
	cp -r ~/.xmonad/.stack-work ~/.sandbox-backup-delta/$date/stack-work
	cp -r ~/.xmonad/stack.yaml ~/.sandbox-backup-delta/$date/stack.yaml
}

create_backups
	
mv ~/.sandbox-backup-delta/$date ~/.sandbox-backup/

find ~/.sandbox-backup -maxdepth 1 -mtime +5 -exec rm -f -r {} \;
