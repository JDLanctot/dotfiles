#!/bin/bash

# Define colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration paths mapping
declare -A CONFIG_PATHS=(
    ["nvim,source"]="config/nvim"
    ["nvim,target"]="$HOME/.config/nvim"
    ["nvim,type"]="directory"
    
    ["bat,source"]="config/bat/config"
    ["bat,target"]="$HOME/.config/bat/config"
    ["bat,type"]="file"
    
    ["julia,source"]=".julia/config/startup.jl"
    ["julia,target"]="$HOME/.julia/config/startup.jl"
    ["julia,type"]="file"
    
    ["zsh,source"]=".zshrc"
    ["zsh,target"]="$HOME/.zshrc"
    ["zsh,type"]="file"
    
    ["starship,source"]=".config/starship.toml"
    ["starship,target"]="$HOME/.config/starship.toml"
    ["starship,type"]="file"
)

backup_configuration() {
    local path=$1
    local type=$2
    
    if [ -e "$path" ]; then
        local timestamp=$(date +%Y%m%d_%H%M%S)
        local backup_path="${path}.backup_${timestamp}"
        
        if [ "$type" = "directory" ]; then
            cp -r "$path" "$backup_path"
        else
            cp "$path" "$backup_path"
        fi
        
        if [ $? -eq 0 ]; then
            print_success "Backed up $path to $backup_path"
            echo "$backup_path"
            return 0
        else
            print_error "Failed to backup $path"
            return 1
        fi
    fi
}

restore_configuration() {
    local backup_path=$1
    local target_path=$2
    local type=$3
    
    if [ -e "$backup_path" ]; then
        if [ "$type" = "directory" ]; then
            rm -rf "$target_path"
            cp -r "$backup_path" "$target_path"
        else
            cp "$backup_path" "$target_path"
        fi
        
        if [ $? -eq 0 ]; then
            print_success "Restored $target_path from backup"
            return 0
        else
            print_error "Failed to restore from backup"
            return 1
        fi
    fi
    return 1
}

install_configuration() {
    local name=$1
    local temp_path=$2
    
    local source_path="$temp_path/${CONFIG_PATHS[${name},source]}"
    local target_path="${CONFIG_PATHS[${name},target]}"
    local type="${CONFIG_PATHS[${name},type]}"
    
    # Create target directory if it doesn't exist
    mkdir -p "$(dirname "$target_path")"
    
    # Backup existing configuration
    local backup_path=""
    if [ -e "$target_path" ]; then
        backup_path=$(backup_configuration "$target_path" "$type")
    fi
    
    if [ -e "$source_path" ]; then
        if [ "$type" = "directory" ]; then
            rm -rf "$target_path"
            cp -r "$source_path" "$target_path"
        else
            cp "$source_path" "$target_path"
        fi
        
        if [ $? -eq 0 ]; then
            print_success "$name configuration installed"
            return 0
        else
            print_error "Failed to install $name configuration"
            if [ -n "$backup_path" ]; then
                restore_configuration "$backup_path" "$target_path" "$type"
            fi
            return 1
        fi
    else
        print_error "$name configuration not found in dotfiles"
        if [ -n "$backup_path" ]; then
            restore_configuration "$backup_path" "$target_path" "$type"
        fi
        return 1
    fi
}


# Function to print colored status messages
print_status() {
    echo -e "${BLUE}[STATUS]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check the version of something
check_version() {
    local current=$1
    local required=$2
    printf '%s\n%s\n' "$required" "$current" | sort -V | head -n1
}

# Check if a component is already installed
declare -A INSTALLED_COMPONENTS
save_state() {
    local component=$1
    INSTALLED_COMPONENTS[$component]=1
    echo "$component" >> ~/.dotfiles_installed
}
check_state() {
    local component=$1
    [[ -f ~/.dotfiles_installed ]] && grep -q "^$component$" ~/.dotfiles_installed
}

create_directory() {
    local dir=$1
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir" || {
            print_error "Failed to create directory: $dir"
            return 1
        }
        print_success "Created directory: $dir"
    else
        print_status "Directory already exists: $dir"
    fi
}

# Function to install basic dependencies
install_dependencies() {
    print_status "Installing basic dependencies..."
    
    local packages=("curl" "wget" "git" "unzip")
    local installed_packages=()
    local failed_packages=()
    
    # Update package list only if needed
    if [[ ! -f /var/cache/apt/pkgcache.bin ]] || [[ $(find /var/cache/apt/pkgcache.bin -mmin +60) ]]; then
        sudo apt-get update
    fi
    
    for package in "${packages[@]}"; do
        if ! command_exists "$package"; then
            if sudo apt-get install -y "$package"; then
                installed_packages+=("$package")
            else
                failed_packages+=("$package")
            fi
        else
            print_status "$package is already installed"
        fi
    done
    
    if [[ ${#installed_packages[@]} -gt 0 ]]; then
        print_success "Installed packages: ${installed_packages[*]}"
    fi
    
    if [[ ${#failed_packages[@]} -gt 0 ]]; then
        print_error "Failed to install packages: ${failed_packages[*]}"
        return 1
    fi
    
    save_state "basic_dependencies"
}


# Function to install and configure zsh
install_zsh() {
    if check_state "zsh"; then
        print_status "Zsh already installed and configured"
        return 0
    }

    print_status "Installing and configuring Zsh..."
    
    # Install Zsh
    if ! command_exists zsh; then
        sudo apt-get install -y zsh
        if ! command_exists zsh; then
            print_error "Zsh installation failed"
            return 1
        fi
        print_success "Zsh installed"
    else
        print_status "Zsh already installed"
    fi
    
    # Install Oh My Zsh if not present
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_status "Installing Oh My Zsh..."
        if ! sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; then
            print_error "Oh My Zsh installation failed"
            return 1
        fi
        print_success "Oh My Zsh installed"
    else
        print_status "Oh My Zsh already installed"
    fi
    
    # Install plugins
    local plugins_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    
    # Install zsh-autosuggestions
    if [ ! -d "$plugins_dir/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$plugins_dir/zsh-autosuggestions"
        print_success "zsh-autosuggestions installed"
    fi
    
    # Install zsh-completions
    if [ ! -d "$plugins_dir/zsh-completions" ]; then
        git clone https://github.com/zsh-users/zsh-completions "$plugins_dir/zsh-completions"
        print_success "zsh-completions installed"
    fi
    
    # Backup existing configurations
    for file in ".zshrc" ".zshenv" ".bashrc"; do
        if [ -f "$HOME/$file" ]; then
            cp "$HOME/$file" "$HOME/${file}.backup"
        fi
    done
    
    # Copy new configurations from dotfiles
    if [ -f "dotfiles/.zshrc" ]; then
        cp "dotfiles/.zshrc" "$HOME/"
        print_success ".zshrc configured"
    else
        print_error ".zshrc not found in dotfiles"
        return 1
    fi
    
    if [ -f "dotfiles/.zshenv" ]; then
        cp "dotfiles/.zshenv" "$HOME/"
        print_success ".zshenv configured"
    fi
    
    if [ -f "dotfiles/.bashrc" ]; then
        cp "dotfiles/.bashrc" "$HOME/"
        print_success ".bashrc configured"
    fi
    
    # Verify configurations
    if ! grep -q "zsh-autosuggestions" "$HOME/.zshrc"; then
        echo "source $plugins_dir/zsh-autosuggestions/zsh-autosuggestions.zsh" >> "$HOME/.zshrc"
    fi
    
    if ! grep -q "zsh-completions" "$HOME/.zshrc"; then
        echo "fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src" >> "$HOME/.zshrc"
    fi
    
    # Set Zsh as default shell if it isn't already
    if [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s "$(which zsh)"
        print_success "Zsh set as default shell"
    fi
    
    save_state "zsh"
    print_success "Zsh setup completed"
    return 0
}

install_starship() {
    if check_state "starship"; then
        print_status "Starship already installed and configured"
        return 0
    }

    print_status "Installing and configuring Starship..."
    
    # Install Starship
    if ! command_exists starship; then
        curl -sS https://starship.rs/install.sh | sh -s -- --yes
        if ! command_exists starship; then
            print_error "Starship installation failed"
            return 1
        fi
        print_success "Starship installed"
    else
        print_status "Starship already installed"
    fi
    
    # Create config directory
    mkdir -p ~/.config
    
    # Backup existing configuration
    if [ -f ~/.config/starship.toml ]; then
        mv ~/.config/starship.toml ~/.config/starship.toml.backup
    fi
    
    # Copy configuration from dotfiles
    if [ -f "dotfiles/.config/starship.toml" ]; then
        cp "dotfiles/.config/starship.toml" ~/.config/
        print_success "Starship configuration installed"
    else
        print_error "starship.toml not found in dotfiles"
        return 1
    fi
    
    # Add Starship initialization to shell configs if not already present
    local init_cmd='eval "$(starship init bash)"'
    if [ -f ~/.bashrc ] && ! grep -q "$init_cmd" ~/.bashrc; then
        echo "$init_cmd" >> ~/.bashrc
    fi
    
    init_cmd='eval "$(starship init zsh)"'
    if [ -f ~/.zshrc ] && ! grep -q "$init_cmd" ~/.zshrc; then
        echo "$init_cmd" >> ~/.zshrc
    fi
    
    save_state "starship"
    print_success "Starship setup completed"
    return 0
}

# Function to install zsh plugins
install_zsh_plugins() {
    print_status "Installing Zsh plugins..."

    # Install Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_success "Oh My Zsh installed"
    fi

    # Install zsh-autosuggestions
    if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        print_success "zsh-autosuggestions installed"
    fi
    
    # Install zsh-completions
    if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions" ]; then
        git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
        print_success "zsh-completions installed"
    fi

    print_success "Zsh plugins installed successfully"
}

# Function to install additional utilities
install_utilities() {
    print_status "Installing additional utilities..."
    
    # Install unzip
    sudo apt-get install -y unzip
    print_success "Unzip installed"
    
    # Install eza
    sudo apt-get update
    sudo apt-get install -y eza
    print_success "Eza installed"
}

# Function to install git and setup SSH
install_git_ssh() {
    if check_state "git_ssh"; then
        print_status "Git and SSH already configured"
        return 0
    }

    print_status "Setting up Git and SSH..."
    
    # Install Git if not present
    if ! command_exists git; then
        sudo apt-get update
        sudo apt-get install -y git
        
        if ! command_exists git; then
            print_error "Git installation failed"
            return 1
        fi
        print_success "Git installed"
    else
        print_status "Git already installed: $(git --version)"
    fi
    
    # Configure Git
    local current_email=$(git config --global user.email || echo "")
    local current_name=$(git config --global user.name || echo "")
    
    if [ -z "$current_email" ] && [ -z "$GIT_EMAIL" ]; then
        read -p "Enter your Git email: " GIT_EMAIL
    fi
    
    if [ -z "$current_name" ] && [ -z "$GIT_NAME" ]; then
        read -p "Enter your Git name: " GIT_NAME
    fi
    
    if [ "$current_email" != "$GIT_EMAIL" ]; then
        git config --global user.email "$GIT_EMAIL"
        print_success "Git email configured"
    fi
    
    if [ "$current_name" != "$GIT_NAME" ]; then
        git config --global user.name "$GIT_NAME"
        print_success "Git name configured"
    fi
    
    # Setup SSH key if it doesn't exist
    if [ ! -f ~/.ssh/id_ed25519 ]; then
        # Create .ssh directory with proper permissions
        mkdir -p ~/.ssh
        chmod 700 ~/.ssh
        
        # Generate SSH key
        ssh-keygen -t ed25519 -C "${GIT_EMAIL}" -f ~/.ssh/id_ed25519 -N ""
        
        # Configure SSH agent
        if ! pgrep -u "$USER" ssh-agent > /dev/null; then
            eval "$(ssh-agent -s)"
        fi
        
        # Add SSH key to agent
        ssh-add ~/.ssh/id_ed25519
        
        # Add SSH config if it doesn't exist
        if [ ! -f ~/.ssh/config ]; then
            cat > ~/.ssh/config << EOL
Host github.com
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/id_ed25519
EOL
            chmod 600 ~/.ssh/config
        fi
        
        # Display public key and wait for GitHub setup
        echo -e "\n${GREEN}[ACTION REQUIRED]${NC} Add this SSH key to your GitHub account:"
        cat ~/.ssh/id_ed25519.pub
        echo -e "\nPress Enter after adding the key to GitHub..."
        read
        
        # Test connection
        if ! ssh -T git@github.com -o StrictHostKeyChecking=no; then
            print_error "GitHub SSH connection test failed"
            return 1
        fi
        
        print_success "SSH key setup completed"
    else
        print_status "SSH key already exists"
        # Test existing SSH connection
        if ! ssh -T git@github.com -o BatchMode=yes; then
            print_error "Existing SSH key is not working with GitHub"
            return 1
        fi
    fi
    
    save_state "git_ssh"
    print_success "Git and SSH setup completed"
}

# Function to install and configure starship prompt
install_starship() {
    print_status "Installing Starship prompt..."
    if ! command_exists starship; then
        curl -sS https://starship.rs/install.sh | sh -s -- -y
        print_success "Starship installed successfully"
    else
        print_status "Starship is already installed"
    fi
}

install_cli_tools() {
    if check_state "cli_tools"; then
        print_status "CLI tools already installed"
        return 0
    fi

    print_status "Installing CLI tools..."
    local failed_installs=()
    
    # Silver Searcher (ag)
    if ! command_exists ag; then
        if sudo apt-get install -y silversearcher-ag; then
            print_success "Silver Searcher (ag) installed"
        else
            failed_installs+=("ag")
        fi
    else
        print_status "Silver Searcher (ag) already installed"
    fi
    
    # bat
    if ! command_exists bat; then
        if sudo apt-get install -y bat; then
            # Handle Ubuntu/Debian bat->batcat symlink
            if command_exists batcat && ! command_exists bat; then
                mkdir -p ~/.local/bin
                ln -sf /usr/bin/batcat ~/.local/bin/bat
                export PATH="$HOME/.local/bin:$PATH"
            fi
            print_success "bat installed"
        else
            failed_installs+=("bat")
        fi
    else
        print_status "bat already installed"
    fi
    
    # fzf
    if ! command_exists fzf; then
        if sudo apt-get install -y fzf; then
            # Setup fzf configuration if not already done
            if [ ! -f ~/.fzf.zsh ]; then
                if [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
                    cp /usr/share/doc/fzf/examples/key-bindings.zsh ~/.fzf.zsh
                    echo "[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh" >> ~/.zshrc
                    print_success "fzf key bindings configured"
                fi
            fi
            print_success "fzf installed"
        else
            failed_installs+=("fzf")
        fi
    else
        print_status "fzf already installed"
    fi
    
    # zoxide
    if ! command_exists zoxide; then
        if sudo apt-get install -y zoxide; then
            # Configure shell integration if not already done
            if ! grep -q "zoxide init" ~/.zshrc; then
                echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc
            fi
            if ! grep -q "zoxide init" ~/.bashrc; then
                echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
            fi
            print_success "zoxide installed and configured"
        else
            failed_installs+=("zoxide")
        fi
    else
        print_status "zoxide already installed"
    fi
    
    if [[ ${#failed_installs[@]} -gt 0 ]]; then
        print_error "Failed to install: ${failed_installs[*]}"
        return 1
    fi
    
    save_state "cli_tools"
    print_success "CLI tools installation completed"
}

# Function to install Julia
install_julia() {
    if check_state "julia"; then
        print_status "Julia already installed"
        return 0
    }

    print_status "Installing Julia..."
    
    # Define versions and paths
    local JULIA_VERSION="1.8.5"
    local JULIA_DIR="julia-${JULIA_VERSION}"
    local JULIA_ARCHIVE="${JULIA_DIR}-linux-x86_64.tar.gz"
    local JULIA_URL="https://julialang-s3.julialang.org/bin/linux/x64/1.8/${JULIA_ARCHIVE}"
    
    # Check if Julia is already installed and verify version
    if command_exists julia; then
        local current_version=$(julia --version | cut -d' ' -f3)
        if check_version "$current_version" "$JULIA_VERSION"; then
            print_status "Julia $current_version is already installed"
            # Still ensure config is set up
            setup_julia_config
            save_state "julia"
            return 0
        else
            print_status "Upgrading Julia from $current_version to $JULIA_VERSION"
        fi
    fi
    
    # Download and verify Julia
    print_status "Downloading Julia..."
    if ! curl -L -o "$JULIA_ARCHIVE" "$JULIA_URL"; then
        print_error "Failed to download Julia"
        return 1
    fi
    
    # Extract Julia
    if ! tar -xzf "$JULIA_ARCHIVE"; then
        print_error "Failed to extract Julia"
        rm -f "$JULIA_ARCHIVE"
        return 1
    fi
    
    # Install Julia
    if [ -d "/opt/$JULIA_DIR" ]; then
        sudo rm -rf "/opt/$JULIA_DIR"
    fi
    
    if ! sudo mv "$JULIA_DIR" /opt/; then
        print_error "Failed to move Julia to /opt"
        rm -f "$JULIA_ARCHIVE"
        rm -rf "$JULIA_DIR"
        return 1
    fi
    
    # Create symlink
    sudo ln -sf "/opt/$JULIA_DIR/bin/julia" /usr/local/bin/julia
    
    # Verify installation
    if ! command_exists julia; then
        print_error "Julia installation failed"
        return 1
    fi
    
    # Clean up
    rm -f "$JULIA_ARCHIVE"
    
    # Setup Julia configuration
    setup_julia_config
    
    save_state "julia"
    print_success "Julia installation completed"
}

# Function to install Zig
install_zig() {
    if check_state "zig"; then
        print_status "Zig already installed"
        return 0
    }

    print_status "Installing Zig..."
    
    # Try snap installation first
    if command_exists snap; then
        if ! command_exists zig; then
            if sudo snap install zig --classic --edge; then
                print_success "Zig installed via snap"
                save_state "zig"
                return 0
            fi
        fi
    fi
    
    # Fallback to manual installation if snap fails
    if ! command_exists zig; then
        print_status "Attempting manual Zig installation..."
        
        # Get latest version from GitHub
        local latest_version=$(curl -s https://ziglang.org/download/index.json | grep -oP '(?<="version": ")[^"]*' | head -1)
        local download_url="https://ziglang.org/download/${latest_version}/zig-linux-x86_64-${latest_version}.tar.xz"
        
        # Download and extract
        if curl -L -o zig.tar.xz "$download_url" && \
           tar xf zig.tar.xz && \
           sudo mv zig-linux-* /usr/local/zig && \
           sudo ln -sf /usr/local/zig/zig /usr/local/bin/zig; then
            
            rm zig.tar.xz
            print_success "Zig installed manually"
            
            # Verify installation
            if command_exists zig; then
                local zig_version=$(zig version)
                print_success "Zig $zig_version installed successfully"
                save_state "zig"
                return 0
            fi
        fi
        
        print_error "Failed to install Zig"
        return 1
    else
        local zig_version=$(zig version)
        print_status "Zig $zig_version is already installed"
        save_state "zig"
    fi
}

# Function to install Neovim
install_neovim() {
    if check_state "neovim"; then
        print_status "Neovim already installed and configured"
        return 0
    }

    print_status "Installing Neovim..."
    
    # Required dependencies
    local deps=(
        "ninja-build"
        "gettext"
        "cmake"
        "unzip"
        "curl"
        "pkg-config"
    )
    
    # Install dependencies
    for dep in "${deps[@]}"; do
        if ! command_exists "$dep"; then
            sudo apt-get install -y "$dep"
        fi
    done
    
    # Add Neovim unstable PPA
    if ! grep -q "^deb .*neovim-ppa/unstable" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
        sudo add-apt-repository ppa:neovim-ppa/unstable -y
        sudo apt-get update
    fi
    
    # Install or upgrade Neovim
    if command_exists nvim; then
        local current_version=$(nvim --version | head -n1 | cut -d' ' -f2)
        if check_version "$current_version" "0.9.0"; then
            print_status "Neovim $current_version already installed"
        else
            print_status "Upgrading Neovim from $current_version"
            sudo apt-get install -y neovim
        fi
    else
        sudo apt-get install -y neovim
    fi
    
    # Verify installation
    if ! command_exists nvim; then
        print_error "Neovim installation failed"
        return 1
    fi
    
    # Create config directories
    mkdir -p ~/.config/nvim/{lua,autoload,backup,swap,undo}
    
    # Backup existing configuration
    if [ -f ~/.config/nvim/init.lua ]; then
        mv ~/.config/nvim/init.lua ~/.config/nvim/init.lua.backup
    fi
    
    # Copy configuration from dotfiles
    if [ -d "dotfiles/config/nvim" ]; then
        cp -r dotfiles/config/nvim/* ~/.config/nvim/
        print_success "Neovim configuration installed"
        
        # Install plugins
        print_status "Installing Neovim plugins (this may take a while)..."
        if ! nvim --headless "+Lazy! sync" +qa; then
            print_error "Plugin installation failed"
            # Restore backup if it exists
            if [ -f ~/.config/nvim/init.lua.backup ]; then
                mv ~/.config/nvim/init.lua.backup ~/.config/nvim/init.lua
            fi
            return 1
        fi
    else
        print_error "Neovim configuration not found in dotfiles"
        return 1
    fi
    
    save_state "neovim"
    print_success "Neovim setup completed"
}

# Function to install Node.js and pnpm
install_node() {
    if check_state "nodejs"; then
        print_status "Node.js and pnpm already installed"
        return 0
    }

    print_status "Installing Node.js and pnpm..."
    
    # Install nvm if not present
    if ! command_exists nvm; then
        export NVM_DIR="$HOME/.nvm"
        if [ ! -d "$NVM_DIR" ]; then
            # Get latest nvm version
            local NVM_LATEST=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
            curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_LATEST/install.sh" | bash
            
            # Setup nvm in current session
            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
            [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
            
            print_success "nvm installed"
        else
            print_status "nvm directory exists, attempting to load"
            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        fi
    fi
    
    # Verify nvm installation
    if ! command_exists nvm; then
        print_error "nvm installation failed"
        return 1
    fi
    
    # Install latest LTS version of Node.js if not present
    if ! command_exists node; then
        nvm install --lts
        nvm use --lts
        
        # Verify Node.js installation
        if ! command_exists node; then
            print_error "Node.js installation failed"
            return 1
        fi
        
        local node_version=$(node --version)
        print_success "Node.js $node_version installed"
    else
        local node_version=$(node --version)
        print_status "Node.js $node_version is already installed"
    fi
    
    # Install or update pnpm
    if ! command_exists pnpm; then
        npm install -g pnpm
        if ! command_exists pnpm; then
            print_error "pnpm installation failed"
            return 1
        fi
        local pnpm_version=$(pnpm --version)
        print_success "pnpm $pnpm_version installed"
    else
        local pnpm_version=$(pnpm --version)
        print_status "pnpm $pnpm_version is already installed"
    fi
    
    save_state "nodejs"
    print_success "Node.js environment setup completed"
}

# Function to setup configuration directories
setup_config_dirs() {
    print_status "Creating configuration directories..."
    
    # Create necessary directories
    mkdir -p ~/.config/nvim
    mkdir -p ~/.config/bat
    mkdir -p ~/.julia/config
    
    print_success "Configuration directories created"
}

# Function to setup dotfiles
setup_dotfiles() {
    if check_state "dotfiles"; then
        print_status "Dotfiles already configured"
        return 0
    fi
    
    print_status "Setting up dotfiles..."
    
    # Use absolute paths for temp directory
    local temp_path="/tmp/dotfiles_$(date +%s)"
    [ -d "$temp_path" ] && rm -rf "$temp_path"
    
    # Use absolute paths everywhere
    if git clone https://github.com/JDLanctot/dotfiles.git "$temp_path"; then
        local failed=false
        
        for name in "nvim" "bat" "julia" "zsh" "starship"; do
            print_status "Installing $name configuration..."
            if ! install_configuration "$name" "$temp_path"; then
                failed=true
                break
            fi
        done
        
        # Cleanup using absolute path
        rm -rf "$temp_path"
        
        if [ "$failed" = false ]; then
            save_state "dotfiles"
            print_success "Dotfiles setup completed"
            return 0
        fi
        
        return 1
    else
        print_error "Failed to clone dotfiles repository"
        return 1
    fi
}

install_julia() {
    if check_state "julia"; then
        print_status "Julia already installed"
        return 0
    }

    print_status "Installing Julia..."
    
    # Define versions and paths
    local JULIA_VERSION="1.8.5"
    local JULIA_DIR="julia-${JULIA_VERSION}"
    local JULIA_ARCHIVE="${JULIA_DIR}-linux-x86_64.tar.gz"
    local JULIA_URL="https://julialang-s3.julialang.org/bin/linux/x64/1.8/${JULIA_ARCHIVE}"
    
    # Check if Julia is already installed and verify version
    if command_exists julia; then
        local current_version=$(julia --version | cut -d' ' -f3)
        if check_version "$current_version" "$JULIA_VERSION"; then
            print_status "Julia $current_version is already installed"
            # Still ensure config is set up
            setup_julia_config
            save_state "julia"
            return 0
        else
            print_status "Upgrading Julia from $current_version to $JULIA_VERSION"
        fi
    fi
    
    # Download and verify Julia
    print_status "Downloading Julia..."
    if ! curl -L -o "$JULIA_ARCHIVE" "$JULIA_URL"; then
        print_error "Failed to download Julia"
        return 1
    fi
    
    # Extract Julia
    if ! tar -xzf "$JULIA_ARCHIVE"; then
        print_error "Failed to extract Julia"
        rm -f "$JULIA_ARCHIVE"
        return 1
    fi
    
    # Install Julia
    if [ -d "/opt/$JULIA_DIR" ]; then
        sudo rm -rf "/opt/$JULIA_DIR"
    fi
    
    if ! sudo mv "$JULIA_DIR" /opt/; then
        print_error "Failed to move Julia to /opt"
        rm -f "$JULIA_ARCHIVE"
        rm -rf "$JULIA_DIR"
        return 1
    fi
    
    # Create symlink
    sudo ln -sf "/opt/$JULIA_DIR/bin/julia" /usr/local/bin/julia
    
    # Verify installation
    if ! command_exists julia; then
        print_error "Julia installation failed"
        return 1
    fi
    
    # Clean up
    rm -f "$JULIA_ARCHIVE"
    
    # Setup Julia configuration
    setup_julia_config
    
    save_state "julia"
    print_success "Julia installation completed"
}

# Function to configure Git
configure_git() {
    local email=$1
    local name=$2
    
    local current_email=$(git config --global user.email)
    local current_name=$(git config --global user.name)
    
    if [[ "$current_email" != "$email" ]]; then
        git config --global user.email "$email"
        print_success "Git email configured"
    fi
    
    if [[ "$current_name" != "$name" ]]; then
        git config --global user.name "$name"
        print_success "Git name configured"
    fi
}

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Store the original directory
ORIGINAL_DIR="$(pwd)"

# Function to ensure we're working from a known directory
set_working_directory() {
    local target_dir="$1"
    if ! cd "$target_dir"; then
        print_error "Failed to change directory to $target_dir"
        return 1
    fi
    return 0
}

# Function to restore original directory
reset_working_directory() {
    cd "$ORIGINAL_DIR"
}


# Main installation function
main() {
    print_status "Starting installation..."

    # Store current directory and move to script directory
    if ! set_working_directory "$SCRIPT_DIR"; then
        print_error "Failed to set working directory"
        exit 1
    fi

    # Ensure we always return to the original directory
    trap reset_working_directory EXIT

    # Check if running on WSL
    if grep -q microsoft /proc/version; then
        print_status "WSL detected"
    else
        print_status "Native Linux detected"
    fi

    # Define installation steps
    declare -A steps=(
        [1]="install_dependencies"
        [2]="install_git_ssh"
        [3]="setup_config_dirs"
        [4]="setup_dotfiles"
        [5]="install_zsh"
        [6]="install_zsh_plugins"
        [7]="install_starship"
        [8]="install_cli_tools"
        [9]="install_neovim"
        [10]="install_node"
        [11]="install_julia"
        [12]="install_zig"
    )

    # Track failures
    failed=false
    failed_steps=()

    # Execute installation steps
    for i in "${!steps[@]}"; do
        step_name=${steps[$i]}
        print_status "Starting step $i: ${step_name//_/ }"
        
        if ! eval "$step_name"; then
            print_error "Step $i (${step_name//_/ }) failed"
            failed_steps+=("$step_name")
            failed=true
            break
        fi
    done

    # Report results
    if [ "$failed" = true ]; then
        print_error "Installation failed at: ${failed_steps[*]}"
        print_status "You can retry the installation after fixing the issues"
        print_status "Already completed steps have been saved and will be skipped"
        exit 1
    else
        print_success "Installation completed successfully!"
        if [ -f ~/.zshrc ]; then
            print_status "Please restart your terminal or run 'source ~/.zshrc' to apply changes"
        else
            print_status "Please restart your terminal to apply changes"
        fi
    fi
}

# Call main function with error handling
if ! main; then
    print_error "Installation failed"
    exit 1
fi
