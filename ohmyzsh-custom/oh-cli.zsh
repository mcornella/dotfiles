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

# Add 'oh my zsh' command to reload the zsh session
functions[_oh::my::zsh]="${functions[_oh::my::reload]}"

# This is a hack to offer:
#
# • 1st argument: "my"
#
# • next arguments: use _omz function while faking the argument position
#   to be n-1 (2nd argument in _oh will be 1st in _omz, and so on).
#   Also add "zsh" as an argument equivalent to reload.
#
autoload -Uz regexp-replace
functions[_oh]="${functions[_omz]}"
regexp-replace 'functions[_oh]' \
  'if \(\( CURRENT == 2 \)\)' \
  '
    cmds+=("zsh:Reload the current zsh session")
    if (( CURRENT-- == 2 )); then
      compadd "my"
      return 0
    fi
    ${MATCH}
  '
compdef _oh oh
