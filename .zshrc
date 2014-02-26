# Path to your oh-my-zsh configuration.
ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to enable command autocorrection
ENABLE_CORRECTION="true"

# Uncomment following line if you want to disable command arguments autocorrection
DISABLE_CORRECTION_ARGS="true"

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

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git batcharge z dict npm fuck)

source "$ZSH/oh-my-zsh.sh"

# if not running interactively, skip the rest
[[ -z "$PS1" ]] && return

# Idle title
ZSH_THEME_TERM_TITLE_IDLE="%m: %~"

# complete . and .. directories
zstyle ':completion:*' special-dirs true

# ls completion dir_colors
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

# paginated completion
zstyle ':completion:*' list-prompt   ''
zstyle ':completion:*' select-prompt ''

# Example aliases
alias ohmyzsh="subl ~/.oh-my-zsh"
alias zshconfig="subl ~/.zshrc"
alias zshreload=". ~/.zshrc"


## User configuration

# Package suggestions on command not found
[[ -f /etc/zsh_command_not_found ]] && . /etc/zsh_command_not_found

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

## Sourcing extern files

# aliases
[[ -f ~/.aliases ]] && . ~/.aliases

# functions
[[ -f ~/.functions ]] && . ~/.functions

## PATH settings

# DISCUSSION:
# 1) path settings should all go to .profile?
# 2) how to prevent duplicates
# 3) which syntax to use to be portable (related: 2)

# source path modifications
# [[ -f ~/.paths ]] && . ~/.paths

# force unique values in $PATH
typeset -U path

# bin folders
path+="$HOME/bin"
for i in "${HOME}"/bin/*/; do path+="${i%/}" done > /dev/null 2>&1

# android
if [ -d "$HOME/dev/android" ]; then
  path+="$HOME/dev/android/tools"
  path+="$HOME/dev/android/platform-tools"
fi

# current directory at the end
path+=.


## TETRIS!
autoload -U tetris
zle -N tetris
bindkey ^T tetris

# extended globbing (adds ^ and other symbols as wildcards)
setopt extended_glob
# correct behaviour when specifying commit parent (commit^)
alias git='noglob git'
