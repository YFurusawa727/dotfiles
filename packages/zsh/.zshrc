eval "$(starship init zsh)"
. /opt/homebrew/opt/asdf/libexec/asdf.sh

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

### peco settings
# history ctrl-r
function peco-history-selection() {
    BUFFER=`history -n 1 | tac  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection

# cdr ctrl-e
function peco-get-destination-from-cdr() {
  cdr -l | \
  sed -e 's/^[[:digit:]]*[[:blank:]]*//' | \
  peco --query "$LBUFFER"
}
function peco-cdr() {
  local destination="$(peco-get-destination-from-cdr)"
  if [ -n "$destination" ]; then
    BUFFER="cd $destination"
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N peco-cdr
bindkey '^E' peco-cdr

export LANG=ja_JP.UTF-8
export KCODE=u

source ~/.bashrc