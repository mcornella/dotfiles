# add shell level information to prompt for when dealing with nested zsh sessions
RPROMPT+="${RPROMPT+ }%(2L.{%F{yellow}%L%f}.)"
ZLE_RPROMPT_INDENT=$(( SHLVL > 1 ? 0 : ZLE_RPROMPT_INDENT ))
RPROMPT='$(virtualenv_prompt_info)'" $RPROMPT"

# add color to correct prompt
SPROMPT="Correct '%F{red}%R%f' to '%F{green}%r%f' [nyae]? "

# and to xtrace prompt for debugging (+_describe:76> )
# - this weird-looking thing creates a _def<num> function that will be run before the first prompt and remove itself
# - this can be reused for any other pieces of code that need to be run immediately after the startup
function _def$((++_def)) { typeset -g PS4='+%F{green}%N%f:%F{yellow}%i%F{red}>%f '; }
functions[_def$_def]+="; set -A precmd_functions \${precmd_functions:#_def$_def}; unset -f _def$_def; unset _def"
precmd_functions+=("_def$_def")

# show comments in fast-syntax-highlighting
typeset -A FAST_HIGHLIGHT_STYLES
FAST_HIGHLIGHT_STYLES[comment]='fg=006'

# enable color support
dircolors=${commands[dircolors]:-$commands[gdircolors]}
if [[ -n "$dircolors" ]]; then
  test -r ~/.zsh/dircolors && eval "$($dircolors -b ~/.zsh/dircolors)" || eval "$($dircolors -b)"
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi
unset dircolors
