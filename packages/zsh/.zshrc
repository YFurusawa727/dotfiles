eval "$(starship init zsh)"

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fzf
eval "$(fzf --zsh)"

export FZF_DEFAULT_OPTS='--height 40% --reverse --border --color=fg:#d4d4d4,bg:#1e1e1e,hl:#3794ff,fg+:#ffffff,bg+:#2d2d2d,hl+:#3794ff,info:#ffcc02,prompt:#bc3fbc,pointer:#f44747,marker:#4ec9b0'

### fzf settings
# history ctrl-r (override fzf default with dedup)
function fzf-history-selection() {
    BUFFER=$(history -n 1 | awk '!a[$0]++' | fzf --tac --no-sort --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N fzf-history-selection
bindkey '^R' fzf-history-selection

# cdr ctrl-e
function fzf-cdr() {
  local destination=$(cdr -l | sed -e 's/^[[:digit:]]*[[:blank:]]*//' | fzf --query "$LBUFFER")
  if [ -n "$destination" ]; then
    BUFFER="cd $destination"
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N fzf-cdr
bindkey '^E' fzf-cdr

export LANG=ja_JP.UTF-8
export LC_CTYPE=ja_JP.UTF-8

# Load bash aliases if bashrc exists
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/opt/homebrew/share/google-cloud-sdk/path.zsh.inc' ]; then . '/opt/homebrew/share/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc' ]; then . '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc'; fi
export PATH="$HOME/.asdf/shims:$PATH"
