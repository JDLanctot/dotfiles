# Alias
# ---
#
# mac OS shortcuts
#alias code="open -a 'Visual Studio Code'"

# COMMON ALIASES
alias ls="exa --icons --group-directories-first"
alias la="exa --icons --group-directories-first -all"
alias ll="exa --icons --group-directories-first -l"

# EFFICIENCT ALIASES
alias g="goto"
alias c="clear"
alias x="exit"
alias e="code -n ~/ ~/.zshrc ~/.aliases ~/.colors ~/.hooks"
alias r="source ~/.zshrc"

# HISTORY ALIASES
alias h="history -10" # last 10 history commands
alias hc="history -c" # clear history
alias hg="history | grep " # +command

# PERSONAL ALIASES
alias grep='grep --color'
alias python="/usr/bin/python3"
alias distro='cat /etc/*-release'
alias sapu='sudo apt-get update'
alias zshc='nvim $HOME/.zshrc'
alias p='python3'

# Movements Aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
