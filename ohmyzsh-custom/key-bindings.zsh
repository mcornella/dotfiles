## Key bindings
bindkey '^U' kill-buffer        # delete whole buffer
bindkey '^[i' undo              # ALT + i more accessible Undo
bindkey '^[[3;3~' kill-word     # ALT + DEL deletes whole forward-word
bindkey '^H' backward-kill-word # CTRL + BACKSPACE deletes whole backward-word
bindkey '^[l' down-case-word    # ALT + L lowercases word

bindkey '^[^[[D' backward-word  # Option + Left
bindkey '^[^[[C' forward-word   # Option + Right
bindkey '^[[1;3D' backward-word  # Option + Left
bindkey '^[[1;3C' forward-word   # Option + Right

# beginning history search
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search

# insert all matches
zle -C all-matches complete-word _generic
bindkey '^Xa' all-matches
zstyle ':completion:all-matches:*' insert yes
zstyle ':completion:all-matches::::' completer _all_matches _complete
