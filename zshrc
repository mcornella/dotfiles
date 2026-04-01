# Path to your oh-my-zsh configuration.
export ZSH="${ZSH:-$HOME/.zsh/ohmyzsh}"
ZSH_CUSTOM="$HOME/.zsh/ohmyzsh-custom"
ZSH_THEME="robbyrussell"

# Auto update settings
zstyle ':omz:update' mode disabled
zstyle ':omz:update' frequency 0

# Add git function to async
zstyle ':omz:alpha:lib:git' async-functions \
  git_prompt_info \
  git_prompt_status

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Don't resolve symbolic links in z
_Z_NO_RESOLVE_SYMLINKS="true"

# Colorize settings
ZSH_COLORIZE_TOOL=chroma
# Nice ones: arduino friendly paraiso-dark solarized-dark solarized-dark256 vim
ZSH_COLORIZE_STYLE=vim

zstyle :omz:completion fuzzy-match yes

zs_set_path=1

# Add plugins from the command line
[[ -z "$add_plugins" ]] || read -A add_plugins <<< "$add_plugins"
# Which plugins would you like to load?
plugins=(
  brew
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
  colored-man-pages
  copybuffer
  dotenv
  fnm
  rust
  terraform
  virtualenv
  python
  poetry
  shrink-path
  docker
  # custom plugins go here
  ragequit
  # add_plugins from the command line
  $add_plugins
  zsh-no-ps2
  fast-syntax-highlighting
  zsh-sweep
)
unset add_plugins

# Don't load Oh My Zsh on Linux TTYs
[[ -z "$OMZ_LOAD" && $TTY = /dev/tty* && $OSTYPE = linux* ]] || source "$ZSH/oh-my-zsh.sh"

## User configuration

## Sourcing external files
[[ -f ~/.zsh/aliases    ]] && . ~/.zsh/aliases    # custom aliases
[[ -f ~/.zsh/functions  ]] && . ~/.zsh/functions  # custom functions

# add current directory to the end of PATH
path+=(.)

# Load per-host zshrc overriding files
# ^(bck|new) - matching anything except "bck" and "new" (e.g. .zshrc.bck or .zshrc.new)
# (N) - NULL_GLOB: match nothing without giving error if there are no matches
for file in "$ZDOTDIR"/.zshrc.^(bck|new)(N); do . "$file"; done; unset file
