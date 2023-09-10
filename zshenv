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

[ ! -t 0 ] || [ -z "$ZSH_VERSION" ] || {
  function echo-off {
    {
      autoload -Uz add-zsh-hook
      stty_bck=$(stty --save)     # back up stty settings
      stty -echo                  # disable echo
      add-zsh-hook precmd echo-on # make sure echo-on next time the prompt is shown
      unfunction $0               # delete function
    } 2>/dev/null
  }
  function echo-on {
    {
      autoload -Uz add-zsh-hook
      [[ -z "$stty_bck" ]] || stty "$stty_bck"  # restore stty settings
      unset stty_bck                            # delete stty backup variable
      add-zsh-hook -d precmd echo-on            # remove echo-on from precmd hook
      unfunction echo-on                        # delete function
    } 2>/dev/null
  }
  echo-off
}

# bin folders
if [ -d "$HOME"/bin ]; then
  PATH="$HOME/bin:$PATH"
  for DIR in "$(find "$HOME/bin" -mindepth 1 -maxdepth 1 -print)"; do
    test -d "$DIR" && PATH="$DIR:$PATH"
  done > /dev/null 2>&1
fi

if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi

# opt folder
if [ -d "$HOME"/opt ]; then
  for DIR in "$(find "$HOME/opt/" -mindepth 1 -maxdepth 1 -print)"; do
    test -d "$DIR/bin" && PATH="$PATH:$DIR/bin"
  done > /dev/null 2>&1
fi

### NODE

# node, npm binaries and settings
test -d "$HOME/.npm/bin" && PATH="$HOME/.npm/bin:$PATH"
export NPM_CONFIG_PREFIX=~/.npm
export NODE_REPL_HISTORY=

# pnpm
export PNPM_HOME="/home/marc/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

# fnm
test -d "$HOME/.local/share/fnm" && {
  export PATH="$PATH:$HOME/.local/share/fnm"
  [[ -z "${ZSH_VERSION}" ]] && eval "$(fnm env --shell bash)" || eval "$(fnm env --shell zsh)"
  test -f "$HOME/.zsh/completions/_fnm" \
  || fnm completions --shell zsh > "$HOME/.zsh/completions/_fnm"
}

# deno
test -d "$HOME/.deno/bin" && PATH="$PATH:$HOME/.deno/bin"

# bun
test -d "$HOME/.bun" && {
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
}

### RUBY

# ruby gems
if command -v ruby >/dev/null 2>&1 && command -v gem >/dev/null 2>&1; then
  DIR="$(gem environment gempath 2>/dev/null | cut -d: -f1)"
  test -d "$DIR/bin" && PATH="$PATH:$DIR/bin"
fi

unset DIR

# rvm
[[ -d "$HOME/.rvm" ]] && PATH="$PATH:$HOME/.rvm/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

### OTHERS

# android
test -d /opt/android && PATH="$PATH:/opt/android/platform-tools:/opt/android/tools"

# composer binaries
test -d "$HOME"/.composer/vendor/bin && PATH="$PATH:$HOME/.composer/vendor/bin"

# go binaries and workspace
test -d /usr/local/go && PATH="$PATH:/usr/local/go/bin"
test -d "$HOME/code/go" && {
  export GOPATH="$HOME/code/go"
  PATH="$PATH:$HOME/code/go/bin"
}

# rust cargo
test -f "$HOME/.cargo/env" && . "$HOME/.cargo/env"

# sdkman
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && {
  export SDKMAN_DIR="$HOME/.sdkman"
  source "${SDKMAN_DIR}/bin/sdkman-init.sh"
}

[ -n "$ZSH_VERSION" ] && {
  # move history file
  HISTFILE="$HOME"/.zsh/.history

  # remove duplicate entries from PATH
  typeset -U path
  fpath+=("$HOME/.zsh/completions")
}

# export PATH for other sessions
export PATH

# use nano if it exists; otherwise use vim
command -v nano > /dev/null 2>&1 && export EDITOR=nano || export EDITOR=vim

# set less options by default:
# -F: quit if output is less than one screen
# -R: keep color control chars
export LESS=-FR
export LESSHISTFILE=-
# --redraw-on-quit: print last screen when exiting less (v594 and newer)
[ $(less -V | awk '{print $2;exit}' | sed 's/[^0-9]//g') -ge 594 ] && {
  export LESS="-FR --redraw-on-quit"
  READNULLCMD=$(command -v less)
  export PAGER="$READNULLCMD"
}

[ "$USER" = root ] && ZSH_DISABLE_COMPFIX=true

skip_global_compinit=1

find "$(dirname -- "$0")" -name '.zshenv.*' -print0 | while read -d $'\0' file; do
  source "$file"
done
unset file
