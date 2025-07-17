# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# User configuration
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd beep extendedglob nomatch notify
bindkey -e

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/too_faeded/.zshrc'
autoload -Uz compinit
compinit
# End of lines added by compinstall

# Load Starship
eval "$(starship init zsh)"

# Initialize zoxide
eval "$(zoxide init zsh)"

# Set up fzf key bindings and fuzzy completion
[[ -f ~/.fzf.zsh ]] && source ~.fzf.zsh
source /usr/share/doc/fzf/examples/key-bindings.zsh  # /opt/homebrew/opt/fzf/shell/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh # /opt/homebrew/opt/fzf/shell/completion.zsh
export FZF_DEFAULT_OPTS="--height 40% --reverse --border"
export FZF_DEFAULT_SORT="true"
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

# Source various files for zsh
[[ -f ~/.zsh/aliases.zsh ]] && source ~/.zsh/aliases.zsh
[[ -f ~/.zsh/functions.zsh ]] && source ~/.zsh/functions.zsh
[[ -f ~/.zsh/keybinds.zsh ]] && source ~/.zsh/keybinds.zsh
[[ -f ~/.zsh/starship.zsh ]] && source ~/.zsh/starship.zsh
#[[ -f ~/.zsh/nvm.zsh ]] && source ~/.zsh/nvm.zsh
[[ -f ~/.zsh/wsl2fix.zsh ]] && source ~/.zsh/wsl2fix.zsh
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/toofaeded/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/toofaeded/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/toofaeded/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/toofaeded/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
