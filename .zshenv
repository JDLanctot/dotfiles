# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Julia Directory
export PATH=~/julia-1.8.5/bin:$PATH

# Zig Directory
export PATH=$PATH:/usr/local/zig

# NVM directory
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Vagrant config needed inside WSL2
#export VAGRANT_DEFAULT_PROVIDER="hyperv"
#export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"

#export EDITOR=hx
#export KUBE_EDITOR=hx

#export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
