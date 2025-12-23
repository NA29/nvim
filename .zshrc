##############################
# My improved zshrc          #
##############################

# --------------------------------------------------
# Environment and shell options
# --------------------------------------------------

setopt INC_APPEND_HISTORY SHARE_HISTORY
setopt APPEND_HISTORY
setopt CORRECT
setopt MENUCOMPLETE
setopt ALL_EXPORT
setopt notify globdots correct pushdtohome cdablevars autolist
setopt correctall autocd recexact longlistjobs
setopt autoresume histignoredups pushdsilent
setopt autopushd pushdminus extendedglob rcquotes mailwarning
unsetopt bgnice autoparamslash

# --------------------------------------------------
# Modules
# --------------------------------------------------

zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
# zmodload -ap zsh/mapfile mapfile

# --------------------------------------------------
# History
# --------------------------------------------------

HISTFILE=$HOME/.zhistory
HISTSIZE=10000
SAVEHIST=10000

# --------------------------------------------------
# Aliases
# --------------------------------------------------

if [ -f ~/.zsh_aliases ]; then
  source ~/.zsh_aliases
fi

alias ls='ls -c --color=auto'
alias la='ls -ac --color=auto'
alias ll='ls -lah --color=auto'
alias lsd='ls -d */'
alias lsg='ls --color=auto | g'
alias lag='ls -a --color=auto | g'
alias llg='ls -lah --color=auto | g'

alias g="grep --color=always"
alias gi="grep -i --color=always"

alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'
alias rmf='rm -Rfv'
alias cpf='\cp -v'
alias mvf='\mv -v'

alias nv="nvim"
alias lg="lazygit"

# --------------------------------------------------
# Completion & key bindings
# --------------------------------------------------

autoload -Uz compinit
compinit -C   # faster, no insecure dir warnings

bindkey "^?" backward-delete-char
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[6~' down-line-or-history
bindkey "^r" history-incremental-search-backward
bindkey ' ' magic-space
bindkey '^I' complete-word

# --------------------------------------------------
# Completion styling
# --------------------------------------------------

zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select=1
zstyle ':completion:*' verbose yes

zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

zstyle ':completion:*:*:kill:*:processes' list-colors \
  '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*:processes' \
  command 'ps --forest -A -o pid,user,cmd'
zstyle ':completion:*:processes-names' command 'ps axho command'

# --------------------------------------------------
# Prompt
# --------------------------------------------------

PROMPT='%n@%m %1~ %F{green}%#%f '

# --------------------------------------------------
# Homebrew
# --------------------------------------------------

eval "$(/opt/homebrew/bin/brew shellenv)"

# --------------------------------------------------
# Tooling & SDKs
# --------------------------------------------------

# Angular CLI
source <(ng completion script)

# Google Cloud SDK
if [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]; then
  source "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"
fi

if [ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]; then
  source "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"
fi

# Android / Java
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools

export JAVA_HOME=$HOME/Library/Java/JavaVirtualMachines/ms-17.0.16/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH

# pipx
export PATH="$PATH:$HOME/.local/bin"

# thefuck
eval "$(thefuck --alias)"

# --------------------------------------------------
# Autosuggestions
# --------------------------------------------------

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
bindkey '^[[Z' autosuggest-accept

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# --------------------------------------------------
# Syntax highlighting (MUST BE LAST)
# --------------------------------------------------

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# initialize Starship prompt
eval "$(starship init zsh)"
