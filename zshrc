# Path to your oh-my-zsh configuration.
export ZSH="$HOME/.zsh/ohmyzsh"
ZSH_CUSTOM="$HOME/.zsh/ohmyzsh-custom"

# Auto update settings
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 1

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Don't resolve symbolic links in z
_Z_NO_RESOLVE_SYMLINKS="true"

# Colorize settings
ZSH_COLORIZE_TOOL=chroma
# Nice ones: arduino friendly paraiso-dark solarized-dark solarized-dark256 vim
ZSH_COLORIZE_STYLE=vim

# Add plugins from the command line
[[ -z "$add_plugins" ]] || read -A add_plugins <<< "$add_plugins"
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
  extract
  history-substring-search
  npm
  yarn
  github
  docker-compose
  sublime
  colorize
  colored-man-pages
  copybuffer
  dotenv
  grc
  fnm
  rust
  # custom plugins go here
  zsh-syntax-highlighting
  git-prompt
  ragequit
  k
  # add_plugins from the command line
  $add_plugins
)
unset add_plugins

# Don't load Oh My Zsh on TTYs
[[ -z "$OMZ_LOAD" && $TTY = /dev/tty* && $(uname -a) != ([Dd]arwin*|[Mm]icrosoft*) ]] \
  || source "$ZSH/oh-my-zsh.sh"

## User configuration

ZSH_THEME_TERM_TAB_TITLE_IDLE="%~"

# Fix invisible comments in zsh-syntax-highlighting
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]="fg=cyan"

# add shell level information to prompt for when dealing with nested zsh sessions
RPROMPT+="${RPROMPT+ }%(2L.{%F{yellow}%L%f}.)"
ZLE_RPROMPT_INDENT=$(( SHLVL > 1 ? 0 : ZLE_RPROMPT_INDENT ))

# add color to correct prompt
SPROMPT="Correct '%F{red}%R%f' to '%F{green}%r%f' [nyae]? "

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

# Docker completion option stacking
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# correct behaviour when specifying commit parent (commit^)
alias git='noglob git'

# prevent adding files as key strokes when using bindkey
alias bindkey='noglob bindkey'

## Key bindings
bindkey '^U' kill-buffer        # delete whole buffer
bindkey '^[i' undo              # ALT + i more accessible Undo
bindkey '^[[3;3~' kill-word     # ALT + DEL deletes whole forward-word
bindkey '^H' backward-kill-word # CTRL + BACKSPACE deletes whole backward-word
bindkey '^[l' down-case-word    # ALT + L lowercases word

# beginning history search
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search

# insert all matches
zle -C all-matches complete-word _generic
bindkey '^Xa' all-matches
zstyle ':completion:all-matches:*' insert yes
zstyle ':completion:all-matches::::' completer _all_matches _complete

## More zsh options
setopt correct        # correction of commands
setopt extended_glob  # adds ^ and other symbols as wildcards
setopt share_history  # i want all typed commands to be available everywhere

# zmv (mass mv / cp / ln)
autoload zmv
alias mmv='noglob zmv -W -v'

# zed (zsh editor)
autoload -Uz zed

# make less more friendly for non-text input files, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

## Sourcing external files
[[ -f ~/.zsh/aliases    ]] && . ~/.zsh/aliases    # custom aliases
[[ -f ~/.zsh/functions  ]] && . ~/.zsh/functions  # custom functions

# Workaround for https://github.com/ohmyzsh/ohmyzsh/issues/10156
autoload +X -Uz _git && _git &>/dev/null
functions[_git-stash]=${functions[_git-stash]//\\_git-notes /}

# add current directory to the end of PATH
path+=(.)
