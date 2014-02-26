#!/bin/zsh
#
# Symlinks files in this directory into $HOME directory

# Base dir
DIR="$( cd "$( dirname "$0" )" && pwd )"

# Files to be symlinked to home directory
dotfiles=(.aliases .dircolors .functions .gitconfig .toprc .zshrc)

for file in $dotfiles; do
    echo -n "symlinking $file... "
    ln -s $DIR/$file $HOME/$file >/dev/null 2>&1 && echo "[ok]" || echo "[error]"
done
