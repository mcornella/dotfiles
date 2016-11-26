# ZSH theme based on tutorial from Nettuts+. See more:
# http://net.tutsplus.com/tutorials/tools-and-tips/how-to-customize-your-command-prompt/

# displays the user prompt
function omz_doubleend_prompt() {
  emulate -L zsh
  zmodload zsh/mathfunc

  function _de_battery() {
    BAT0=/sys/class/power_supply/BAT0

    # is battery present?
    [[ -r $BAT0/present ]] || return
    command grep -q 1 $BAT0/present || return

    # battery status
    b_status=""
    command grep -q Discharging $BAT0/status   || b_status="charging"
    command grep -E -q '^0$' $BAT0/current_now || b_status="discharging"

    case "$b_status" in
      discharging)
        glyph_full='◂'
        glyph_void='◃'
        ;;
      charging)
        glyph_full='▸'
        glyph_void='▹'
        ;;
      *)
        glyph_full='◈'
        glyph_void='◇'
        ;;
    esac

    # current charge?
    [[ -r $BAT0/charge_full ]] || return
    f_max="$(command cat $BAT0/charge_full)"
    [[ -r $BAT0/charge_now ]] || return
    f_cur="$(command cat $BAT0/charge_now)"

    i_charge=0
    if (( f_max > 0 )); then i_charge=$(( int(ceil(float(f_cur) / f_max * 10.0) ) )); fi
    i_discharge=$(( 10 - i_charge ))

    full=$([[ $i_charge    -ne 0 ]] && printf "$glyph_full%.0s" {1..$i_charge})
    void=$([[ $i_discharge -ne 0 ]] && printf "$glyph_void%.0s" {1..$i_discharge})

    if [[ $i_charge -gt 6 ]]; then
      color='%{%F{green}%}'
    elif [[ $i_charge -gt 2 ]]; then
      color='%{%F{yellow}%}'
    else
      color='%{%F{red}%}'
    fi

    echo -n "$(printf '%s%s%s%s' $color $full $void "%{%f%}")"
  }

  function _de_spacing() {
    local host="$(print -Pn $(_de_host))"
    host=${#host} && [[ $host -gt 0 ]] && host=$(( $host - 10 )) # substract color escaping

    local dir="$(print -Pn $(_de_dir))"
    dir=${#dir} && [[ $dir -gt 0 ]] && dir=$(( $dir - 10 )) # substract color escaping

    local git="$(print -Pn $(_de_git))"
    git=${#git} && [[ $git -gt 0 ]] && git=$(( $git - 10 )) # substract color escaping

    local bat="$(print -Pn $(_de_battery))"
    bat=${#bat} && [[ $bat -gt 0 ]] && bat=$(( $bat - 10 )) # substract color escaping

    # terminal width available
    local termwidth=$(( $COLUMNS - $host - $dir - $git - $bat - 2 )) # 2 for prompt spaces
    [[ $termwidth -lt 0 ]] && termwidth=$(( $termwidth + $COLUMNS * int(ceil(- float($termwidth) / $COLUMNS )) ))

    printf ' %.0s' {1..$termwidth}
  }

  function _de_git() {
    local ZSH_THEME_GIT_PROMPT_PREFIX="[git:"
    local ZSH_THEME_GIT_PROMPT_SUFFIX="]%{%f%}"
    local ZSH_THEME_GIT_PROMPT_DIRTY="%{%F{red}%}+"
    local ZSH_THEME_GIT_PROMPT_CLEAN="%{%F{green}%}"

    if [[ "$(command git config --get oh-my-zsh.hide-status)" != "1" ]]; then
      ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
      ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
      echo -n "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
    fi
  }

  function _de_host() {
    echo -n "%{%F{cyan}%}%m:%{%f%}"
  }

  function _de_dir() {
    echo -n "%{%F{yellow}%}%~%{%f%}"
  }

  function _de_user() {
    echo -n "%(!.%{%F{red}%}.%{%f%})→%{%f%} "
  }

  # display the prompt
  echo -n "$(_de_host) $(_de_dir)$(_de_spacing)$(_de_git) $(_de_battery)$(_de_user)"
}

PROMPT='
$(omz_doubleend_prompt)'
