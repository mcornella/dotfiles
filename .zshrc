# Path to your oh-my-zsh configuration.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to enable command autocorrection
# ENABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to  shown in the command execution time stamp
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
# HIST_STAMPS="dd.mm.yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(
	git
	git-extras
	gitignore
	dircycle
	web-search
	sudo
	zsh_reload
	vagrant
	composer
	npm
	# gem
	z
	batcharge
	ragekill
)

source "$ZSH/oh-my-zsh.sh"


## User configuration

# Disable showing prompt context (user@host)
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
alias ohmyzsh="subl ~/.oh-my-zsh"
alias zshrc="subl ~/.zshrc"

# correct behaviour when specifying commit parent (commit^)
alias git='noglob git'
# prevent adding files as key strokes when using bindkey
alias bindkey='noglob bindkey'


## More zsh options

# automatic rehashing of commands...
zstyle ':completion:*' rehash true
# ...and checking if they're actually executable before adding them
setopt hashexecutablesonly

# correction of commands
setopt correct

# extended globbing (adds ^ and other symbols as wildcards)
setopt extended_glob
# allow pasting comments in interactive shell
setopt interactivecomments

## TETRIS!
autoload -U tetris
zle -N tetris
bindkey ^T tetris

# zmv
autoload zmv
alias zmv='noglob zmv -W'


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
