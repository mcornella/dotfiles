# ZSH theme based on tutorial from Nettuts+. See more:
# http://net.tutsplus.com/tutorials/tools-and-tips/how-to-customize-your-command-prompt/

# displays the user prompt
function prompt_doubleend() {
  emulate -L zsh
  zmodload zsh/mathfunc

  function _de_battery() {
    local BAT=/sys/class/power_supply/BAT0
    [[ ! -d $BAT ]] && BAT=/sys/class/power_supply/BAT1

    # is battery present?
    command grep -q 1 $BAT/present 2>/dev/null || return

    # battery status
    local b_status
    command grep -q Discharging $BAT/status   2>/dev/null || b_status="charging"
    command grep -E -q '^0$' $BAT/current_now 2>/dev/null || b_status="discharging"

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
    [[ -r $BAT/charge_full && -r $BAT/charge_now ]] || return
    local f_max="$(< $BAT/charge_full)"
    local f_cur="$(< $BAT/charge_now)"

    i_charge=0
    if (( f_max > 0 )); then i_charge=$(( int(ceil(float(f_cur) / f_max * 10.0) ) )); fi
    i_discharge=$(( 10 - i_charge ))

    full=$([[ $i_charge    -ne 0 ]] && printf "$glyph_full%.0s" {1..$i_charge})
    void=$([[ $i_discharge -ne 0 ]] && printf "$glyph_void%.0s" {1..$i_discharge})

    if [[ $i_charge -gt 6 ]]; then
      color='%F{green}'
    elif [[ $i_charge -gt 2 ]]; then
      color='%F{yellow}'
    else
      color='%F{red}'
    fi

    echo "$(printf '%s%s%s%s' $color $full $void "%f")"
  }

  function _de_git() {
    local ZSH_THEME_GIT_PROMPT_PREFIX="[git:"
    local ZSH_THEME_GIT_PROMPT_SUFFIX="]%f"
    local ZSH_THEME_GIT_PROMPT_DIRTY="%F{red}+"
    local ZSH_THEME_GIT_PROMPT_CLEAN="%F{green}"

    if [[ "$(command git config --get oh-my-zsh.hide-status)" != "1" ]]; then
      ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
      ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
      echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
    fi
  }

  function _de_host() {
    echo "%F{cyan}%m:%f"
  }

  function _de_dir() {
    echo "%F{yellow}%~%f"
  }

  function _de_user() {
    echo "%(!.%F{red}.)→%f "
  }

  # run prompt functions
  local host dir git battery user
  host="$(print -P "$(_de_host)")"
  dir="$(print -P "$(_de_dir)")"
  git="$(print -P "$(_de_git)")"
  battery="$(print -P "$(_de_battery)")"
  user="$(print -P "$(_de_user)")"

  # compute spacing
  local _i_host=${#host} && [[ $_i_host -gt 0 ]] && _i_host=$(( $_i_host - 10 )) # substract color escaping
  local _i_dir=${#dir} && [[ $_i_dir -gt 0 ]] && _i_dir=$(( $_i_dir - 10 )) # substract color escaping
  local _i_git=${#git} && [[ $_i_git -gt 0 ]] && _i_git=$(( $_i_git - 10 )) # substract color escaping
  local _i_battery=${#battery} && [[ $_i_battery -gt 0 ]] && _i_battery=$(( $_i_battery - 10 )) # substract color escaping

  # terminal width available
  local _i_spacing=$(( COLUMNS - _i_host - _i_dir - _i_git - _i_battery - 2 )) # 2 for prompt spaces
  [[ $_i_spacing -lt 0 ]] && _i_spacing=$(( _i_spacing + COLUMNS * int(ceil(- float(_i_spacing) / COLUMNS )) ))

  local spacing
  spacing=$(printf ' %.0s' {1..$_i_spacing})

  # display the prompt
  echo -n "${host} ${dir}${spacing}${git} ${battery}${user}"
}

PROMPT='
$(prompt_doubleend)'
