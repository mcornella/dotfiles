#!/usr/bin/env zsh
#
# Symlinks files in this directory into $HOME directory

# Base dir
DIR="$( cd "$( dirname "$0" )" && pwd )"

# Files to be symlinked to home directory
dotfiles=(
	aliases
	dircolors
	functions
	gitconfig
	nanorc
	nano
	toprc
	vimrc
	zshenv
	zshrc
)

local error
local symlink

for file in $dotfiles; do
	echo -n "symlinking $file... "

	destfile=$HOME/.$file

	if error="$(ln -s $DIR/$file $destfile 2>&1)"
	then
		echo "[OK]"
	elif [[ -h $HOME/$file ]]
	then
		symlink="$(readlink $destfile)"

		if [[ "$symlink" == "$DIR/$file" ]]; then
			echo "[SKIP: file already symlinked]"
		else
			echo "[ERROR: destination already exists ( -> $symlink)]"
		fi
	elif [[ -f $destfile ]]
	then
		echo "[ERROR: destination already exists (file)]"
	elif [[ -d $destfile ]]
	then
		echo "[ERROR: destination already exists (dir)]"
	elif [[ -e $destfile ]]
	then
		echo "[ERROR: destination already exists (other)]"
	else
		echo "[ERROR: $error]"
	fi
done

# TODO: add repositories as needed (i.e. oh-my-zsh)
# TODO: add colored output (green OK, yellow SKIP, red ERROR)
