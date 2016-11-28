# refined code, based on
# http://stackoverflow.com/questions/23456873/multi-dot-paths-in-zsh-like-cd/23471915#23471915

magic-dot() {
  emulate -L zsh

  if [[ ! $LBUFFER =~ '(^|/| |'$'\t''|'$'\n''|\||;|&)\.\.$' ]]; then
    zle self-insert
    return
  fi

  case $LBUFFER in
    p4*) zle self-insert ;;
    *) LBUFFER+=/.. ;;
  esac
}
zle -N magic-dot

bindkey -M emacs . magic-dot
bindkey -M vicmd . magic-dot
bindkey -M isearch . self-insert
