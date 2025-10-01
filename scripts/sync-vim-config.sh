#!/bin/bash

# This script synchronizes the Vim configuration files from a source directory to the user's home directory.
# It backs up existing configuration files before overwriting them.
# Usage: ./sync-vim-config.sh /path/to/source
# Example: ./sync-vim-config.sh ~/my-vim-configuration
# Make sure to run this script with appropriate permissions.
# Author: Your Name
# Date: 2024-06-15
# Version: 1.0
# License: MIT

set -e
SOURCE_DIR="$1"
if [ -z "$SOURCE_DIR" ]; then
	echo "Usage: $0 /path/to/source"
	exit 15
fi
if [ ! -d "$SOURCE_DIR" ]; then
	echo "Error: Source directory '$SOURCE_DIR' does not exist."
	exit 16
fi
BACKUP_DIR="$HOME/vim-config-backup-$(date +%Y%m%d%H%M%S)"
mkdir -p "$BACKUP_DIR/.vim"
echo "Backing up existing Vim configuration files to '$BACKUP_DIR'..."
for file in .vimrc .vim/coc-settings.json .vim/source; do
	if [ -e "$HOME/$file" ]; then
		mv "$HOME/$file" "$BACKUP_DIR/$file"
		echo "Moved '$HOME/$file' to '$BACKUP_DIR/$file'"
	fi
done
echo "Copying new Vim configuration files from '$SOURCE_DIR' to '$HOME'..."
mkdir -p $HOME/.vim
for file in .vimrc .vim/coc-settings.json .vim/source; do
	cp -rp "$SOURCE_DIR/$file" "$HOME/$file"
done
echo "Vim configuration files copied."
echo "Synchronization complete."
exit 0
