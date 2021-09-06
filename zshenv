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

# bin folders
if [ -d "$HOME"/bin ]; then
	PATH="$PATH:$HOME/bin"
	for DIR in "$(find "$HOME/bin" -mindepth 1 -maxdepth 1 -print)"; do
		test -d "$DIR" && PATH="$PATH:$DIR"
	done > /dev/null 2>&1
fi

if [ -d "$HOME/.local/bin" ]; then
	PATH="$PATH:$HOME/.local/bin"
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

# fnm (nvm alternative)
test -d "$HOME/.fnm" && {
	export PATH="$PATH:$HOME/.fnm"
	eval "$(fnm env --shell zsh)"
	test -f "$HOME/.zsh/completions/_fnm" \
	|| fnm completions --shell zsh > "$HOME/.zsh/completions/_fnm"
}

# deno
test -d "$HOME/.deno/bin" && PATH="$PATH:$HOME/.deno/bin"

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

# remove duplicate entries from PATH
[ -n "$ZSH_VERSION" ] && {
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
[ $(less -V | awk '{print $2;exit}' | sed 's/[^0-9]//g') -ge 594 ] && export LESS="-FR --redraw-on-quit"

[ "$USER" = root ] && ZSH_DISABLE_COMPFIX=true

skip_global_compinit=1
