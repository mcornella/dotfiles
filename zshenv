#!/bin/sh
#
# File: .zshenv
# Description:
#   Dynamically sets the PATH at each shell startup.
#   To enable these modifications at logon, source this file from .profile:
#
#     . ~/.zshenv
#
#   For that reason, avoid syntax and commands not portable to other platforms
#   and shells. Check out http://hyperpolyglot.org/unix-shells for more information.


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

# npm binaries
test -d "$HOME/.npm/bin" && PATH="$PATH:$HOME/.npm/bin"

# composer binaries
test -d "$HOME"/.composer/vendor/bin && PATH="$PATH:$HOME/.composer/vendor/bin"

# ruby gems
if which ruby &>/dev/null && which gem &>/dev/null; then
	DIR="$(ruby -rubygems -e 'puts Gem.user_dir' 2>/dev/null)"
	test -d "$DIR/bin" && PATH="$PATH:$DIR/bin"
fi

unset DIR

# remove duplicate entries from PATH
[ -n "$ZSH_VERSION" ] && typeset -U path

# export PATH for other sessions
export PATH

export EDITOR=nano
export GOPATH=~/opt/gocode
