## PATH settings

# DISCUSSION:
# 1) path settings should all go to .profile?
# 2) how to prevent duplicates -> `typeset -U path` to remove duplicates
# 3) which syntax to use to be portable (related [2], or only in zsh?)

# source path modifications
# [[ -f ~/.paths ]] && . ~/.paths

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
