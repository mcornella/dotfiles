#!/bin/zsh
#
# Symlinks files in this directory into $HOME directory

# Base dir
DIR="$( cd "$( dirname "$0" )" && pwd )"

# Files to be symlinked to home directory
dotfiles=()
dotfiles+=.aliases
dotfiles+=.dircolors
dotfiles+=.functions
dotfiles+=.gitconfig
dotfiles+=.toprc
dotfiles+=.vimrc
dotfiles+=.zshrc

local error
local symlink

for file in $dotfiles; do
    echo -n "symlinking $file... "

    if error="$(ln -s $DIR/$file $HOME/$file 2>&1)"
    then
        echo "[OK]"
    elif [[ -h $HOME/$file ]]
    then
        symlink="$(readlink $HOME/$file)"

        if [[ "$symlink" == "$DIR/$file" ]]; then
            echo "[SKIP: file already symlinked]"
        else
            echo "[ERROR: destination already exists ( -> $symlink)]"
        fi
    elif [[ -f $HOME/$file ]]
    then
        echo "[ERROR: destination already exists (file)]"
    elif [[ -d $HOME/$file ]]
    then
        echo "[ERROR: destination already exists (dir)]"
    elif [[ -e $HOME/$file ]]
    then
        echo "[ERROR: destination already exists (other)]"
    else
        echo "[ERROR: $error]"
    fi
done

# TODO: add repositories as needed (i.e. oh-my-zsh)
# TODO: further development and testing
# TODO: add colored output (green OK, yellow SKIP, red ERROR)

