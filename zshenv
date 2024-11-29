#!/bin/sh
#
# File: .zshenv
# Description:
#   Dynamically sets the PATH at each shell startup, as well as other
#   environment variables.
#   To enable these modifications at logon, source this file from .profile:
#
#     . ~/.zshenv
#
#   NOTE: avoid syntax and commands that aren't portable to other platforms and
#   shells. Check out http://hyperpolyglot.org/unix-shells for more information.

if [[ -t 0 && -n "$ZSH_VERSION" && -o interactive ]]; then
  echo:off() {
    autoload -Uz add-zsh-hook
    stty_bck=$(stty -g)         # back up stty settings
    stty -echo                  # disable echo
    add-zsh-hook precmd echo:on # run echo:on next time the prompt is shown
    unfunction echo:off         # delete function
  }
  echo:on() {
    autoload -Uz add-zsh-hook
    [[ -z "$stty_bck" ]] || stty "$stty_bck"  # restore stty settings
    unset stty_bck                            # delete stty backup variable
    add-zsh-hook -d precmd echo:on            # remove echo:on from precmd hook
    unfunction echo:on                        # delete function
  }
  echo:off
fi

# bin folders
if [[ -d "$HOME"/bin ]]; then
  PATH="$HOME/bin:$PATH"
  for DIR in "$(find "$HOME/bin" -mindepth 1 -maxdepth 1 -print)"; do
    [[ -d "$DIR" ]] && PATH="$DIR:$PATH"
  done
fi

if [[ -d "$HOME/.local/bin" ]]; then
  PATH="$HOME/.local/bin:$PATH"
fi

# opt folder
if [[ -d "$HOME"/opt ]]; then
  for DIR in "$(find "$HOME/opt/" -mindepth 1 -maxdepth 1 -print)"; do
    [[ -d "$DIR/bin" ]] && PATH="$PATH:$DIR/bin"
  done
fi

### OTHERS

if [[ -n "$ZSH_VERSION" ]]; then
  # remove duplicate entries from PATH
  typeset -U path
  fpath=("$HOME/.zsh/completions" "${fpath[@]}")

  [[ "$USER" = root ]] && ZSH_DISABLE_COMPFIX=true
  skip_global_compinit=1

  for file in "${0:h}"/.zshenv.*(N); do
    source "$file" 2>/dev/null
  done
  unset file
fi

# export PATH for other sessions
export PATH

# use nano if it exists; otherwise use vim
command -v nano > /dev/null 2>&1 && export EDITOR=nano || export EDITOR=vim

# set less options by default:
# -F: quit if output is less than one screen
# -R: keep color control chars
export LESS=-FR LESSHISTFILE=-
READNULLCMD=less
export PAGER="$READNULLCMD"
# --redraw-on-quit: print last screen when exiting less (v594 and newer)
ver="$(less -V)"; ver="${ver%% \(*}"; ver="${ver#less *}"; ver="${ver%%.*}"
[[ $ver -ge 594 ]] && export LESS="-FR --redraw-on-quit"
unset ver
