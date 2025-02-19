ZSH_THEME_TERM_TAB_TITLE_IDLE="%~"

# correct behaviour when specifying commit parent (commit^)
alias git='noglob git'

# prevent adding files as key strokes when using bindkey
alias bindkey='noglob bindkey'

## More zsh options
setopt correct        # correction of commands
setopt extended_glob  # adds ^ and other symbols as wildcards
setopt share_history  # i want all typed commands to be available everywhere

# zmv (mass mv / cp / ln)
autoload -Uz zmv && alias mmv='noglob zmv -W -v'
# zed (zsh editor)
autoload -Uz zed
# zargs (zsh equivalent for xargs)
autoload -Uz zargs

# make less more friendly for non-text input files, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"
