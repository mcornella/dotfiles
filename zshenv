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
	for DIR in "$HOME"/bin/*; do
		test -d "$DIR" && PATH="$PATH:$DIR"
	done > /dev/null 2>&1
fi

# opt folder
if [ -d "$HOME"/opt ]; then
	for DIR in "$HOME"/opt/*/bin; do
		test -d "$DIR" && PATH="$PATH:$DIR"
	done > /dev/null 2>&1
fi

# android
test -d /opt/android && PATH="$PATH:/opt/android/platform-tools:/opt/android/tools"

# npm binaries and settings
test -d "$HOME/.npm/bin" && PATH="$HOME/.npm/bin:$PATH"
export NPM_CONFIG_PREFIX=~/.npm

# composer binaries
test -d "$HOME"/.composer/vendor/bin && PATH="$PATH:$HOME/.composer/vendor/bin"

# ruby gems
if which ruby &>/dev/null && which gem &>/dev/null; then
	DIR="$(ruby -rubygems -e 'puts Gem.user_dir' 2>/dev/null)"
	test -d "$DIR/bin" && PATH="$PATH:$DIR/bin"
fi

# rust cargo
test -f "$HOME/.cargo/env" && source "$HOME/.cargo/env"

# go binaries and workspace
test -d /usr/local/go && PATH="$PATH:/usr/local/go/bin"
test -d "$HOME/code/gosrc" && {
	export GOPATH=~/code/gosrc
	PATH="$PATH:$HOME/code/gosrc/bin"
}

unset DIR

# remove duplicate entries from PATH
[ -n "$ZSH_VERSION" ] && typeset -U path

# export PATH for other sessions
export PATH

# use nano if it exists; otherwise use vim
command -v nano > /dev/null 2>&1 && export EDITOR=nano || export EDITOR=vim

# set less options by default:
# -F: quit if output is less than one screen
# -X: don't clear the screen after quitting
# -R: keep color control chars
export LESS=-FXR

[[ $UID = 0 ]] && ZSH_DISABLE_COMPFIX=true

skip_global_compinit=1
