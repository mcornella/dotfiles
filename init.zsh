#!/usr/bin/env zsh
#
# Symlinks files in this directory into $HOME directory

zmodload zsh/stat

# Base dir as path relative to $HOME directory
DIR="${0:a:h}"

function msg() {
  case "$1" in
    ERROR) print -Pn '%F{red}' ;;
    SKIP) print -Pn '%F{yellow}' ;;
    OK) print -Pn '%F{green}' ;;
  esac

  [[ -n "$2" ]] && print -n "[$1: $2]" || print -n "[$1]"
  print -P %f
}

function symlink() {
  local error symlink lnflags
  local src dest

  # ln flags change on different platforms
  [[ "$OSTYPE" = darwin* ]] && lnflags="-nsfh" || lnflags="-nsfT"

  src="$1"
  dest="$2"

  if [[ -h "$dest" ]]; then
    symlink="$(zstat +link "$dest")"
    if [[ "$symlink" == "$src" ]]; then
      msg SKIP "file already symlinked"
      continue
    else
      echo -n "(old@ -> $symlink)"
    fi
  fi

  mkdir -p "${dest:h}"
  if error="$(ln $lnflags "$src" "$dest" 2>&1)"; then
    msg OK
  elif [[ -f "$dest" ]]; then
    msg ERROR "destination already exists (file)"
  elif [[ -d "$dest" ]]; then
    msg ERROR "destination already exists (dir)"
  else
    msg ERROR "$error"
  fi
}

local ZDOT=".zsh"

# Files to be symlinked to home directory
local -A dotfiles
dotfiles=(
  aliases             "${ZDOT}/aliases"
  dircolors           "${ZDOT}/dircolors"
  functions           "${ZDOT}/functions"
  git                 ".config/git"
  ohmyzsh             "${ZDOT}/ohmyzsh"
  ohmyzsh-custom      "${ZDOT}/ohmyzsh-custom"
  tigrc               ".config/tig/config"
  tmux.conf           ".tmux.conf"
  toprc               ".config/procps/toprc"
  vimrc               ".vimrc"
  zshenv              "${ZDOT}/.zshenv"
  zshrc               "${ZDOT}/.zshrc"
)

local file src dest
for file (${(ko)dotfiles}); do
  src="$DIR/$file"
  dest="$HOME/${dotfiles[$file]}"

  echo -n "Linking $file... "
  symlink "$src" "$dest"
done

# Files specific to the platform
local system
case "$OSTYPE" in
  darwin*) system=darwin ;;
  linux*) system=linux ;;
esac

local -A platform
platform=(
  nano/darwin/nanorc  ".nanorc"
  nano/others/nanorc  ".config/nano/nanorc"
)

local -aU areas files
areas=(${(ko)platform%%/*})

local area
for area (${(o)areas}); do
  # Select the files based on the system
  files=(${(k)platform[(I)$area/$system/*]})
  # If no match for $system, select others
  (( $#files )) || files=(${(k)platform[(I)$area/others/*]})
  # If others not found, go to next area
  (( $#files )) || continue

  echo "Setting up $area:"

  for file (${(o)files}); do
    src="$DIR/$file"
    dest="$HOME/${platform[$file]}"

    echo -n "Linking $file... "
    symlink "$src" "$dest"
  done
done

# Add ZDOTDIR change to ~/.zshenv
grep -q "ZDOTDIR=" "$HOME/.zshenv" 2>/dev/null || {
  echo -n "setting up ZDOTDIR in ~/.zshenv... "
  # .zshenv might be a symlink, so remove it first
  rm -f ~/.zshenv
  cat > ~/.zshenv <<EOF
ZDOTDIR="\$HOME/${ZDOT}"
. "\$ZDOTDIR/.zshenv"
EOF
  msg OK
}

# Add sourcing of .zshenv to .profile
grep -q "\. \"\$HOME/${dotfiles[zshenv]}\"" ~/.profile 2>/dev/null || {
  [[ -s ~/.profile ]] && echo > ~/.profile || touch ~/.profile
  cat >> ~/.profile <<EOF
# load posix-compatible .zshenv
if [ -r "\$HOME/${dotfiles[zshenv]}" ]; then
    . "\$HOME/${dotfiles[zshenv]}"
fi
EOF
}

mkdir -p "$HOME/.zsh/completions"
