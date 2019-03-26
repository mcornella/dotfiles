#!/usr/bin/env zsh
#
# Symlinks files in this directory into $HOME directory

# Base dir as path relative to $HOME directory
DIR="${${0:a:h}#~/}"

function msg() {
	case "$1":
		ERROR) print -Pn '%F{red}' ;;
		SKIP) print -Pn '%F{yellow}' ;;
		OK) print -Pn '%F{green}' ;;
	esac

	[[ -n $2 ]] && print -n "[$1: $2]" || print -n "[$1]"
	print -P %f
}

# Files to be symlinked to home directory
setopt extended_glob
dotfiles=($DIR/^(LICENSE.txt|README.md)(N^*:t))

local error symlink

for file in $dotfiles; do
	echo -n "symlinking $file... "

	destfile=$HOME/.$file

	if error="$(ln -ns $DIR/$file $destfile 2>&1)"
	then
		msg OK
	elif [[ -h $HOME/$file ]]
	then
		symlink="$(readlink $destfile)"

		if [[ "$symlink" == "$DIR/$file" ]]; then
			msg SKIP "file already symlinked"
		else
			msg ERROR "destination already exists ( -> $symlink)"
		fi
	elif [[ -f $destfile ]]
	then
		msg ERROR "destination already exists (file)"
	elif [[ -d $destfile ]]
	then
		msg ERROR "destination already exists (dir)"
	elif [[ -e $destfile ]]
	then
		msg ERROR "destination already exists (other)"
	else
		msg ERROR "$error"
	fi
done
