#!/bin/zsh
#
# Symlinks files in this directory into $HOME directory

DIR="$( cd "$( dirname "$0" )" && pwd )"
SYMLINKS=(aliases dircolors functions gitconfig toprc zshrc)

for file in $SYMLINKS; do
    echo -n "symlinking $file... "
    ln -s $DIR/$file $HOME/.$file >/dev/null 2>&1 && echo "[ok]" || echo "[error]"
done
