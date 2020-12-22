# Path to your oh-my-zsh configuration.
export ZSH="$HOME/.zsh/ohmyzsh"
ZSH_CUSTOM="$HOME/.zsh/ohmyzsh-custom"

# Uncomment this to disable bi-weekly auto-update checks
#DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Don't resolve symbolic links in z
_Z_NO_RESOLVE_SYMLINKS="true"

# Colorize settings
ZSH_COLORIZE_TOOL=chroma
# Nice ones: arduino friendly paraiso-dark solarized-dark solarized-dark256 vim
ZSH_COLORIZE_STYLE=vim

# Which plugins would you like to load?
if [[ -n "$plugins" ]]; then read -A plugins <<< "$plugins"; else
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
	github
	docker-compose
	sublime
	colorize
	colored-man-pages
	copybuffer
	dotenv
	# custom plugins go here
	git-prompt
	ragequit
	k
)
fi

# Don't load Oh My Zsh on TTYs
[[ $TTY != /dev/tty* || -n "$OMZ_LOAD" ]] && source "$ZSH/oh-my-zsh.sh"


## User configuration

# Disable showing prompt context (user@host) in agnoster theme
prompt_context(){}

ZSH_THEME_TERM_TAB_TITLE_IDLE="%~"

# add shell level information to prompt for when dealing with nested zsh sessions
RPROMPT+="${RPROMPT+ }{%F{yellow}$SHLVL%f}"
ZLE_RPROMPT_INDENT=0

# enable color support
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.zsh/dircolors && eval "$(dircolors -b ~/.zsh/dircolors)" || eval "$(dircolors -b)"

	# ls completion dir_colors
	zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

# complete . and .. directories
zstyle ':completion:*' special-dirs true

# paginated completion
zstyle ':completion:*' list-prompt   ''
zstyle ':completion:*' select-prompt ''

alias ohmyzsh='vsc "$ZSH"'
alias zshrc='vsc ~/.zshrc'

# correct behaviour when specifying commit parent (commit^)
alias git='noglob git'

# prevent adding files as key strokes when using bindkey
alias bindkey='noglob bindkey'

## Key bindings

# ALT + i more accessible Undo
bindkey '^[i' undo
# ALT + DEL deletes whole forward-word
bindkey '^[[3;3~' kill-word
# CTRL + BACKSPACE deletes whole backward-word
bindkey '^H' backward-kill-word
# ALT + L lowercases word
bindkey '^[l' down-case-word

# insert all matches
zle -C all-matches complete-word _generic
bindkey '^Xa' all-matches
zstyle ':completion:all-matches:*' insert yes
zstyle ':completion:all-matches::::' completer _all_matches _complete

## More zsh options

# correction of commands
setopt correct

# extended globbing (adds ^ and other symbols as wildcards)
setopt extended_glob

# i want all typed commands to be available everywhere
setopt share_history

# zmv
autoload zmv
alias mmv='noglob zmv -W -v'

# Docker completion option stacking
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

## Sourcing external files

# make less more friendly for non-text input files, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

# custom aliases
[[ -f ~/.zsh/aliases ]] && . ~/.zsh/aliases

# custom functions
[[ -f ~/.zsh/functions ]] && . ~/.zsh/functions

# add current directory to the end of PATH
path+=.
