# Path to your oh-my-zsh configuration.
export ZSH="$HOME/.zsh/ohmyzsh"
ZSH_CUSTOM="$HOME/.zsh/ohmyzsh-custom"
ZSH_THEME="robbyrussell"

# Auto update settings
zstyle ':omz:update' mode background-alpha
zstyle ':omz:update' frequency 0

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
  mise
  git
  git-extras
  gh
  gcloud
  kubectl
  gitignore
  z
  dircycle
  web-search
  sudo
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
  grc
  fnm
  rust
  terraform
  brew
  virtualenv
  # custom plugins go here
  fast-syntax-highlighting
  ragequit
  zsh-no-ps2
  # add_plugins from the command line
  $add_plugins
)
unset add_plugins

# Don't load Oh My Zsh on TTYs
[[ -z "$OMZ_LOAD" && $TTY = /dev/tty* && $(uname -a) != ([Dd]arwin*|[Mm]icrosoft*) ]] \
  || source "$ZSH/oh-my-zsh.sh"

## User configuration

ZSH_THEME_TERM_TAB_TITLE_IDLE="%~"

# add shell level information to prompt for when dealing with nested zsh sessions
RPROMPT+="${RPROMPT+ }%(2L.{%F{yellow}%L%f}.)"
ZLE_RPROMPT_INDENT=$(( SHLVL > 1 ? 0 : ZLE_RPROMPT_INDENT ))
RPROMPT='$(virtualenv_prompt_info)'" $RPROMPT"

# show comments in fast-syntax-highlighting
typeset -A FAST_HIGHLIGHT_STYLES
FAST_HIGHLIGHT_STYLES[comment]='fg=006'

# add color to correct prompt
SPROMPT="Correct '%F{red}%R%f' to '%F{green}%r%f' [nyae]? "
# and to xtrace prompt for debugging (+_describe:76> )
PS4='+%F{green}%N%f:%F{yellow}%i%F{red}>%f '

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
# zargs (zsh equivalent for xargs)
autoload -Uz zargs

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

# Load per-host zshrc overriding files
for file in "$ZDOTDIR"/.zshrc.^(bck|new)(N); do . "$file"; done; unset file
