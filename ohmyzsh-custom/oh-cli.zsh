# Define `oh` function entrypoint
# 1. Ignore first argument (my):
#    shift $(( $# > 0 )): shifts 1 if some arguments were passed, 0 otherwise
# 2. Use `omz` function body while replacing "omz" references
functions[oh]="
  shift \$(( \$# > 0 ))
  ${${functions[omz]//_omz::/_oh::my::}//omz/oh my}
"

# Rename _omz::* function to _oh::my::*
# Replaces:
#   _omz::* -> _oh::my::*
#    omz    ->  oh my
for fn in ${(k)functions[(I)_omz::*]}; do
  functions[${fn//_omz/_oh::my}]="${${functions[$fn]//_omz::/_oh::my::}//omz/oh my}"
done

# Add logo command
_oh::my::logo() {
  supports_truecolor() {
    case "$COLORTERM" in
    truecolor|24bit) return 0 ;;
    esac

    case "$TERM" in
    iterm           |\
    tmux-truecolor  |\
    linux-truecolor |\
    xterm-truecolor |\
    screen-truecolor) return 0 ;;
    esac

    return 1
  }

  truecolor() {
    printf '\033[38;2;%s;%s;%sm' $1 $2 $3
  }

  256color() {
    printf '\033[38;5;%sm' $1
  }

  local -a rainbow
  if supports_truecolor; then
    rainbow=(
      "$(truecolor 255   0   0)"
      "$(truecolor 255  97   0)"
      "$(truecolor 247 255   0)"
      "$(truecolor   0 255  30)"
      "$(truecolor  77   0 255)"
      "$(truecolor 168   0 255)"
      "$(truecolor 245   0 172)"
    )
  else
    rainbow=(
      "$(256color 196)"
      "$(256color 202)"
      "$(256color 226)"
      "$(256color 082)"
      "$(256color 021)"
      "$(256color 093)"
      "$(256color 163)"
    )
  fi

  printf '%s         %s__      %s           %s        %s       %s     %s__   %s\n'     $rainbow $'\033[0m'
  printf '%s  ____  %s/ /_    %s ____ ___  %s__  __  %s ____  %s_____%s/ /_  %s\n'     $rainbow $'\033[0m'
  printf '%s / __ \\%s/ __ \\  %s / __ `__ \\%s/ / / / %s /_  / %s/ ___/%s __ \\ %s\n' $rainbow $'\033[0m'
  printf '%s/ /_/ /%s / / / %s / / / / / /%s /_/ / %s   / /_%s(__  )%s / / / %s\n'     $rainbow $'\033[0m'
  printf '%s\\____/%s_/ /_/ %s /_/ /_/ /_/%s\\__, / %s   /___/%s____/%s_/ /_/  %s\n'   $rainbow $'\033[0m'
  printf '%s    %s        %s           %s /____/ %s       %s     %s          %s\n'     $rainbow $'\033[0m'

  unset -f truecolor 256color supports_truecolor
}

# Add 'oh my zsh' command to reload the zsh session
_oh::my::zsh() {
  print -ru2 -P "%F{green}%BCongratulations!%b You've found a hidden feature%f 🎉"
  _oh::my::logo >&2
  print -ru2 ""
  print -ru2 -P "%F{yellow}Reloading the zsh session ...%f"

  _oh::my::reload
}

# Define oh completion function
# • 1st argument: "my"
#
# • next arguments: use _omz function while faking the argument position
#   to be n-1 (2nd argument in _oh will be 1st in _omz, and so on).
#
#   > *::message:action
#   > With two colons before the message, the words special array and the
#   > CURRENT special parameter are modified to refer only to the normal
#   > arguments when the action is executed or evaluated.
#
function _oh {
  _arguments '1: :(my)' '*:: :_omz'
}
compdef _oh oh
