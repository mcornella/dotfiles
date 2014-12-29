## PATH settings

# DISCUSSION:
# 1) path settings should all go to .profile?
# 2) how to prevent duplicates -> `typeset -U path` to remove duplicates
# 3) which syntax to use to be portable (related [2], or only in zsh?)

# source path modifications
# [[ -f ~/.paths ]] && . ~/.paths

# bin folders
if [ -d ~/bin ]; then
	path+=(~/bin)
	for dir in ~/bin/*(/); do path+=("$dir"); done > /dev/null 2>&1
	unset dir
fi

# opt folder
if [ -d ~/opt ]; then
	for dir in ~/opt/*(/); do
		[ -d "$dir/bin" ] && path+=("$dir/bin")
	done
	unset dir
fi

# android
if [ -d /opt/android ]; then
	path+=(/opt/android/{platform-,}tools)
fi

# ruby gems
if which ruby &>/dev/null && which gem &>/dev/null; then
  dir="$(ruby -rubygems -e 'puts Gem.user_dir')"
  [ -d "$dir/bin" ] && path+=("$dir/bin")
  unset dir
fi

# remove duplicate entries from PATH
typeset -U path

# export PATH for other sessions
export PATH="$PATH"
