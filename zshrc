# Path to your oh-my-zsh configuration.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load.
[[ -z "$ZSH_THEME" ]] && ZSH_THEME="agnoster"

# Uncomment this to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Don't resolve symbolic links in z
_Z_NO_RESOLVE_SYMLINKS="true"

# Which plugins would you like to load?
plugins=(
	git
	git-extras
	github
	gitignore
	z
	dircycle
	web-search
	sudo
	zsh_reload
	docker
	vagrant
	composer
	laravel5
	rsync
	extract
	history-substring-search
	# custom plugins go here
	ragekill
)

source "$ZSH/oh-my-zsh.sh"


## User configuration

# Disable showing prompt context (user@host) in agnoster theme
prompt_context(){}

# Idle title
ZSH_THEME_TERM_TITLE_IDLE="%m: %~"

# enable color support
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

	# ls completion dir_colors
	zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

# complete . and .. directories
zstyle ':completion:*' special-dirs true

# paginated completion
zstyle ':completion:*' list-prompt   ''
zstyle ':completion:*' select-prompt ''

# Example aliases
if [[ $OSTYPE == cygwin ]]
then
	alias ohmyzsh='subl $(cygpath -w "$ZSH")'
	alias zshrc='subl $(cygpath -w ~/.zshrc)'
else
	alias ohmyzsh='subl "$ZSH"'
	alias zshrc='subl ~/.zshrc'
fi

# correct behaviour when specifying commit parent (commit^)
alias git='noglob hub'
# prevent adding files as key strokes when using bindkey
alias bindkey='noglob bindkey'

## Key bindings

# ALT + DEL deletes whole forward-word
bindkey '^[[3;3~' kill-word
# CTRL + DEL deletes whole forward-word
bindkey '^[[3;5~' kill-word
# CTRL + BACKSPACE deletes whole backward-word
bindkey '^H' backward-kill-word
# lowercase word
bindkey '^[l' down-case-word

## More zsh options

# correction of commands
setopt correct

# extended globbing (adds ^ and other symbols as wildcards)
setopt extended_glob

# allow pasting comments in interactive shell
setopt interactivecomments

# automatic rehashing of commands...
zstyle ':completion:*' rehash true
# ...and checking if they're actually executable before adding them
setopt hashexecutablesonly

# zmv
autoload zmv
alias mmv='noglob zmv -W'

## Sourcing extern files

# Package suggestions on command not found
[[ -f /etc/zsh_command_not_found ]] && . /etc/zsh_command_not_found

# make less more friendly for non-text input files, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

# Open new tab in current directory
[[ -f /etc/profile.d/vte.sh ]] && . /etc/profile.d/vte.sh

# custom aliases
[[ -f ~/.aliases ]] && . ~/.aliases

# custom functions
[[ -f ~/.functions ]] && . ~/.functions

# add current directory to the end of PATH
path+=.
