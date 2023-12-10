# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# NVM directory
#export NVM_DIR="$HOME/.nvm"

# Vagrant config needed inside WSL2
#export VAGRANT_DEFAULT_PROVIDER="hyperv"
#export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"

#export EDITOR=hx
#export KUBE_EDITOR=hx

#export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
