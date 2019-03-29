# Path to your oh-my-zsh configuration.
export ZSH="$HOME/.ohmyzsh"
ZSH_CUSTOM="$HOME/.ohmyzsh-custom"

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
	extract
	history-substring-search
	npm
	yarn
	github
	docker-compose
	# custom plugins go here
	ragequit
)

# Don't load Oh My Zsh on TTYs
[[ $TTY != /dev/tty* || "$(uname -r)" =~ "Microsoft" ]] && source "$ZSH/oh-my-zsh.sh"


## User configuration

# Disable showing prompt context (user@host) in agnoster theme
prompt_context(){}

# Idle title
ZSH_THEME_TERM_TITLE_IDLE="%m: %~"

if [[ $OSTYPE = linux* && "$(uname -r)" =~ "Microsoft" ]]; then
	ZSH_THEME_TERM_TAB_TITLE_IDLE="%n@%m: %~"
fi

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
alias git='noglob git'

# prevent adding files as key strokes when using bindkey
alias bindkey='noglob bindkey'

## Key bindings

# CTRL + U more accessible Undo
bindkey '^U' undo
# CTRL + K deletes whole line
bindkey '^K' kill-buffer
# ALT + DEL deletes whole forward-word
bindkey '^[[3;3~' kill-word
# CTRL + DEL deletes whole forward-word
bindkey '^[[3;5~' kill-word
# CTRL + BACKSPACE deletes whole backward-word
bindkey '^H' backward-kill-word
# ALT + L lowercases word
bindkey '^[l' down-case-word

## More zsh options

# correction of commands
setopt correct

# extended globbing (adds ^ and other symbols as wildcards)
setopt extended_glob

# automatic rehashing of commands...
zstyle ':completion:*' rehash true
# ...and checking if they're actually executable before adding them
setopt hashexecutablesonly

# zmv
autoload zmv
alias mmv='noglob zmv -W'

# Docker completion option stacking
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

## Sourcing external files

# make less more friendly for non-text input files, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

# custom aliases
[[ -f ~/.aliases ]] && . ~/.aliases

# custom functions
[[ -f ~/.functions ]] && . ~/.functions

# add current directory to the end of PATH
path+=.
