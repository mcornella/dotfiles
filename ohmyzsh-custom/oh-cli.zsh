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
