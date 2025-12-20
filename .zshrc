##############################
# My simplified zshrc         #
##############################

# Environment and shell options.
#

setopt INC_APPEND_HISTORY SHARE_HISTORY
setopt APPEND_HISTORY
setopt CORRECT
setopt MENUCOMPLETE
setopt ALL_EXpORT
setopt notify globdots correct pushdtohome cdablevars autolist
setopt correctall autocd recexact longlistjobs
setopt autoresume histignoredups pushdsilent 
setopt autopushd pushdminus extendedglob rcquotes mailwarning
unsetopt bgnice autoparamslash

# Modules
#

zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
# zmodload -ap zsh/mapfile mapfile

# Set history settings.
#
HISTFILE=$HOME/.zhistory
HISTSIZE=10000
SAVEHIST=10000

# Set up must-have aliases and alias file.
#

if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases; fi

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
alias rmf='rm -Rfv'

# Key-bindings.
#

autoload -U compinit
compinit
bindkey "^?" backward-delete-char
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[6~' down-line-or-history
bindkey "^r" history-incremental-search-backward
bindkey ' ' magic-space    # also do history expansion on space
bindkey '^I' complete-word # complete on tab, leave expansion to _expand

# Auto-completion settings.
#

zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
zstyle ':completion:*:expand:*' tag-order all-expansions
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -A -o pid,user,cmd'
zstyle ':completion:*:processes-names' command 'ps axho command'

# Basic prompt configuration (reset to default).
#
# Resetting the prompt to default zsh behavior.

#PROMPT='%F{blue}%~ %(?.%F{green}.%F{red})%#%f '

#PROMPT='%~%# '  # Default prompt format for zsh (user@host:path$)

#RPROMPT=''  # Reset right prompt to empty

#PS2='> '  # Default secondary prompt (for multi-line commands)


eval "$(/opt/homebrew/bin/brew shellenv)"

PROMPT='%n@%m %1~ %F{green}%#%f '



# Load Angular CLI autocompletion.
source <(ng completion script)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/nathanaudegond/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/nathanaudegond/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/nathanaudegond/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/nathanaudegond/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

eval $(thefuck --alias)
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
export JAVA_HOME=/Users/nathanaudegond/Library/Java/JavaVirtualMachines/ms-17.0.16/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH

# Created by `pipx` on 2025-12-19 19:37:58
export PATH="$PATH:/Users/nathanaudegond/.local/bin"

alias lg="lazygit"
