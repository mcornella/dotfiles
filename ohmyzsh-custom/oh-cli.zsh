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

_oh::my::logo() {
  local supports_truecolor=1

  () {
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
  } || supports_truecolor=0

  local -a rainbow
  if (( supports_truecolor )); then
    rainbow=(
      $'\033[38;2;255;0;0m'
      $'\033[38;2;255;97;0m'
      $'\033[38;2;247;255;0m'
      $'\033[38;2;0;255;30m'
      $'\033[38;2;77;0;255m'
      $'\033[38;2;168;0;255m'
      $'\033[38;2;245;0;172m'
    )
  else
    rainbow=(
      $'\033[38;5;196m'
      $'\033[38;5;202m'
      $'\033[38;5;226m'
      $'\033[38;5;082m'
      $'\033[38;5;021m'
      $'\033[38;5;093m'
      $'\033[38;5;163m'
    )
  fi

  printf '%s         %s__      %s           %s        %s       %s     %s__   %s\n'      $rainbow $'\033[0m'
  printf '%s  ____  %s/ /_    %s ____ ___  %s__  __  %s ____  %s_____%s/ /_  %s\n'      $rainbow $'\033[0m'
  printf '%s / __ \\%s/ __ \\  %s / __ `__ \\%s/ / / / %s /_  / %s/ ___/%s __ \\ %s\n'  $rainbow $'\033[0m'
  printf '%s/ /_/ /%s / / / %s / / / / / /%s /_/ / %s   / /_%s(__  )%s / / / %s\n'      $rainbow $'\033[0m'
  printf '%s\\____/%s_/ /_/ %s /_/ /_/ /_/%s\\__, / %s   /___/%s____/%s_/ /_/  %s\n'    $rainbow $'\033[0m'
  printf '%s    %s        %s           %s /____/ %s       %s     %s          %s\n'      $rainbow $'\033[0m'
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
