# History configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

# History options
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt SHARE_HISTORY
unsetopt BANG_HIST

# Other options
setopt AUTO_CD
setopt CORRECT

# Environment Variables
# Basic
export EDITOR="nvim"
export VISUAL="nvim"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export HIST_STAMPS="%Y-%m-%d %H:%M:%S"

# Node
export NVM_DIR="$HOME/.nvm"
export NODE_OPTIONS="--max-old-space-size=4096"

# Python
export PYTHONPATH="$HOME/.local/lib/python3.9/site-packages:$PYTHONPATH"
export VIRTUAL_ENV_DISABLE_PROMPT="1"

# Go
export GOPATH="$HOME/go"

# FZF
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --preview '(highlight -O ansi {} || cat {}) 2> /dev/null | head -500'"

# Other
export JUPYTER_PLATFORM_DIRS="1"

# PATH
export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:$HOME/anaconda3/bin:$GOPATH/bin:$HOME/.cargo/bin:$PATH:."

# Aliases
# Compression
alias gz='tar -xzvf'
alias tgz='tar -xzvf'
alias bz2='tar -xjvf'

# Applications
alias mate='open -a "TextMate"'
alias crm='open -a "Google Chrome"'
alias webstorm='open -a "WebStorm"'
alias idea='open -a "IntelliJ IDEA"'
alias markdown='open -a "Typora"'
alias code='open -a "Visual Studio Code"'

# General
alias his='history'
alias ll='ls -alh'
alias la='ls -a'
alias l='ls -lh'
alias ls='ls --color=auto'
alias vim='nvim'

# Tree
alias t='tree -L 1'
alias t2='tree -L 2'
alias t3='tree -L 3'

# Python
alias pv='python -m venv .venv'

# System
alias zz='source ~/.zshrc'

# Wave
alias wv='wsh view'
alias we='wsh edit'
alias ww='wsh web open'
alias wsv='wsh setvar'
alias wr='wsh run'
alias wrx='wsh run -x'
alias wm='wsh getmeta'
alias wa='wsh ai'

# Common apps
alias c='cursor'
alias v='nvim'
alias p='python'

# System monitoring
alias top='htop'
alias btm='bottom'
alias df='duf'
alias ps='procs'
alias gl='glances'
alias cpu='htop -s PERCENT_CPU'
alias mem='htop -s PERCENT_MEM'
alias disk='duf'
alias sys='glances'

# Key bindings
bindkey -e
bindkey '\e\e[C' forward-word
bindkey '\e\e[D' backward-word

# Custom functions
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Initialize direnv
eval "$(direnv hook zsh)"

# Initialize zoxide
eval "$(zoxide init zsh)"

# Conda initialization
__conda_setup="$($HOME/anaconda3/bin/conda 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/anaconda3/etc/profile.d/conda.sh"
    fi
fi
unset __conda_setup

# NVM configuration
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Rust environment
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env" 