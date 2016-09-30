#!/usr/bin/env zsh
#
# Symlinks files in this directory into $HOME directory

# Base dir as path relative to $HOME directory
DIR="${${0:a:h}#~/}"

# Files to be symlinked to home directory
setopt extended_glob
dotfiles=(^(LICENSE.txt|README.md)(N^*))

local error
local symlink

for file in $dotfiles; do
	echo -n "symlinking $file... "

	destfile=$HOME/.$file

	if error="$(ln -ns $DIR/$file $destfile 2>&1)"
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
