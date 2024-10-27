# Requires -RunAsAdministrator

# Ensure $PROFILE is set correctly
if (-not $PROFILE) {
    $PROFILE = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
}

# Script-wide variables
$script:Config = $null
$script:CONFIG_PATHS = $null
$SCRIPT_LOG_PATH = Join-Path $env:TEMP "windows_setup_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

$INSTALLATION_STATE = @{
    Steps = @{}
    BackupPaths = @{}
    StartTime = $null
}

$INSTALLED_COMPONENTS = @{}

# Get the directory where the script is located
$SCRIPT_DIR = $PSScriptRoot
if (-not $SCRIPT_DIR) {
    $SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Definition
}

# Store the original directory
$ORIGINAL_DIR = Get-Location

function Install-BasicPrograms {
    if (Test-InstallationState "basic_programs") {
        Write-ColorOutput "Basic programs already installed" "Status"
        return
    }

    Write-ColorOutput "Installing basic programs..." "Status"
    
    $programs = @(
        @{Name = "git"; Alias = "git"},
        @{Name = "powershell-core"; Alias = "pwsh"},
        @{Name = "starship"; Alias = "starship"},
        @{Name = "fzf"; Alias = "fzf"},
        @{Name = "ag"; Alias = "ag"},
        @{Name = "bat"; Alias = "bat"}
    )
    
    $failed_installs = @()
    $installed = @()
    
    foreach ($program in $programs) {
        if (-not (Get-Command -Name $program.Alias -ErrorAction SilentlyContinue)) {
            try {
                choco install $program.Name -y
                # Refresh PATH after each installation
                $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + 
                           [System.Environment]::GetEnvironmentVariable("Path","User")
                if (Get-Command -Name $program.Alias -ErrorAction SilentlyContinue) {
                    $installed += $program.Name
                } else {
                    $failed_installs += $program.Name
                }
            }
            catch {
                $failed_installs += $program.Name
            }
        } else {
            Write-ColorOutput "$($program.Name) is already installed" "Status"
        }
    }
    
    if ($installed.Count -gt 0) {
        Write-ColorOutput "Successfully installed: $($installed -join ', ')" "Success"
    }
    
    if ($failed_installs.Count -gt 0) {
        Write-ColorOutput "Failed to install: $($failed_installs -join ', ')" "Error"
        return $false
    }
    
    Save-InstallationState "basic_programs"
    Write-ColorOutput "Basic programs installation completed" "Success"
    return $true
}

# Function to install Chocolatey
function Install-Chocolatey {
    Write-ColorOutput "Installing Chocolatey..." "Status"
    if (-not (Get-Command -Name choco -ErrorAction SilentlyContinue)) {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        Write-ColorOutput "Chocolatey installed successfully" "Success"
    } else {
        Write-ColorOutput "Chocolatey is already installed" "Status"
    }
}

function Install-GitSSH {
    [CmdletBinding()]
    param()

    if (Test-InstallationState "git_ssh") {
        Write-ColorOutput "Git and SSH already configured" "Status"
        return $true
    }

    Write-ColorOutput "Setting up Git and SSH..." "Status"
    
    # Install Git using Chocolatey if not present
    if (-not (Test-Command "git")) {
        try {
            Write-ColorOutput "Installing Git..." "Status"
            Invoke-SafeCommand { choco install git -y } -ErrorMessage "Failed to install Git"
            RefreshPath
            
            if (-not (Test-Command "git")) {
                throw "Git installation failed verification"
            }
        }
        catch {
            Write-ColorOutput "Failed to install Git: $_" "Error"
            return $false
        }
    }
    else {
        $gitVersion = Invoke-SafeCommand { git --version } -ErrorMessage "Failed to get Git version"
        Write-ColorOutput "Git $gitVersion already installed" "Status"
    }
    
    # Configure Git global settings
    try {
        # Get current Git configuration
        $currentEmail = Invoke-SafeCommand { git config --global user.email } -ErrorMessage "Failed to get Git email"
        $currentName = Invoke-SafeCommand { git config --global user.name } -ErrorMessage "Failed to get Git name"
        
        # Configure email if not set
        if ([string]::IsNullOrEmpty($currentEmail)) {
            $GIT_EMAIL = Read-Host "Enter your Git email"
            if ([string]::IsNullOrWhiteSpace($GIT_EMAIL)) {
                Write-ColorOutput "Git email is required" "Error"
                return $false
            }
            Invoke-SafeCommand { git config --global user.email $GIT_EMAIL } -ErrorMessage "Failed to set Git email"
            Write-ColorOutput "Git email configured" "Success"
        } else {
            $GIT_EMAIL = $currentEmail
            Write-ColorOutput "Using existing Git email: $GIT_EMAIL" "Status"
        }
        
        # Configure name if not set
        if ([string]::IsNullOrEmpty($currentName)) {
            $GIT_NAME = Read-Host "Enter your Git name"
            if ([string]::IsNullOrWhiteSpace($GIT_NAME)) {
                Write-ColorOutput "Git name is required" "Error"
                return $false
            }
            Invoke-SafeCommand { git config --global user.name $GIT_NAME } -ErrorMessage "Failed to set Git name"
            Write-ColorOutput "Git name configured" "Success"
        } else {
            $GIT_NAME = $currentName
            Write-ColorOutput "Using existing Git name: $GIT_NAME" "Status"
        }
        
        # Additional Git configurations
        Invoke-SafeCommand { 
            # Set default branch name
            git config --global init.defaultBranch main
            # Configure line endings
            git config --global core.autocrlf true
            # Configure credential helper
            git config --global credential.helper manager-core
        } -ErrorMessage "Failed to set additional Git configurations"
    }
    catch {
        Write-ColorOutput "Failed to configure Git: $_" "Error"
        return $false
    }
    
    # Setup SSH
    try {
        if (-not (Test-Path "~/.ssh/id_ed25519")) {
            # Create .ssh directory
            $sshDir = Join-Path $HOME ".ssh"
            New-SafeDirectory -Path $sshDir -Force
            
            # Generate SSH key
            Write-ColorOutput "Generating new SSH key..." "Status"
            
            # Create temporary script for ssh-keygen
            $tempScript = Join-Path $env:TEMP "generate-ssh-key.ps1"
            @"
`$process = Start-Process -FilePath "ssh-keygen" -ArgumentList `
    "-t", "ed25519", `
    "-C", "$GIT_EMAIL", `
    "-f", "$HOME/.ssh/id_ed25519", `
    "-N", '""' `
    -NoNewWindow -Wait -PassThru
if (`$process.ExitCode -ne 0) { exit 1 }
"@ | Set-Content $tempScript

            # Execute the script
            $result = Start-Process powershell -ArgumentList "-File $tempScript" -Wait -NoNewWindow -PassThru
            if ($result.ExitCode -ne 0) {
                throw "SSH key generation failed"
            }
            
            Remove-Item $tempScript -Force -ErrorAction SilentlyContinue
            
            # Configure and start ssh-agent
            $sshAgentService = Get-Service -Name ssh-agent -ErrorAction Stop
            if ($sshAgentService.StartType -ne 'Automatic') {
                Set-Service -Name ssh-agent -StartupType Automatic
            }
            if ($sshAgentService.Status -ne 'Running') {
                Start-Service ssh-agent
            }
            Write-ColorOutput "SSH agent service configured and started" "Success"
            
            # Add SSH key to agent
            $addKeyResult = Start-Process ssh-add -ArgumentList "$HOME/.ssh/id_ed25519" -Wait -NoNewWindow -PassThru
            if ($addKeyResult.ExitCode -ne 0) {
                throw "Failed to add SSH key to agent"
            }
            Write-ColorOutput "SSH key added to agent" "Success"
            
            # Create SSH config
            $sshConfig = @"
Host github.com
    AddKeysToAgent yes
    IdentityFile ~/.ssh/id_ed25519
"@
            Set-Content -Path (Join-Path $sshDir "config") -Value $sshConfig -Force
            Write-ColorOutput "SSH config created" "Success"
            
            # Display public key for GitHub setup
            Write-ColorOutput "ACTION REQUIRED: Add this SSH key to your GitHub account:" "Status"
            Write-ColorOutput "1. Go to GitHub.com → Settings → SSH and GPG keys → New SSH key" "Status"
            Write-ColorOutput "2. Copy the following public key:" "Status"
            Write-Host "`n"
            Get-Content "$HOME/.ssh/id_ed25519.pub"
            Write-Host "`n"
            Write-Host "Press Enter after adding the key to GitHub..."
            Read-Host
            
            # Test connection with retries
            $maxRetries = 3
            $retryCount = 0
            $success = $false
            
            while (-not $success -and $retryCount -lt $maxRetries) {
                try {
                    Write-ColorOutput "Testing GitHub SSH connection (Attempt $($retryCount + 1) of $maxRetries)..." "Status"
                    $null = ssh -T git@github.com -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=10
                    $success = $true
                    Write-ColorOutput "SSH connection test successful" "Success"
                }
                catch {
                    $retryCount++
                    if ($retryCount -eq $maxRetries) {
                        Write-ColorOutput "GitHub SSH connection test failed: $_" "Error"
                        Write-ColorOutput "Please verify that you added the SSH key to your GitHub account correctly" "Error"
                        return $false
                    }
                    Write-ColorOutput "Connection attempt failed. Retrying in 5 seconds..." "Status"
                    Start-Sleep -Seconds 5
                }
            }
        }
        else {
            Write-ColorOutput "SSH key already exists" "Status"
            # Test existing connection
            try {
                Write-ColorOutput "Testing existing GitHub SSH connection..." "Status"
                $null = ssh -T git@github.com -o BatchMode=yes -o ConnectTimeout=10
                Write-ColorOutput "Existing SSH connection verified" "Success"
            }
            catch {
                Write-ColorOutput "Existing SSH key is not working with GitHub: $_" "Error"
                Write-ColorOutput "You may need to regenerate your SSH key or update your GitHub settings" "Error"
                return $false
            }
        }
        
        Save-InstallationState "git_ssh"
        Write-ColorOutput "Git and SSH setup completed" "Success"
        return $true
    }
    catch {
        Write-ColorOutput "Failed during SSH setup: $_" "Error"
        return $false
    }
}

# Function to install CLI tools
function Install-CliTools {
    [CmdletBinding()]
    param()
    
    if (Test-InstallationState "cli_tools") {
        Write-ColorOutput "CLI tools already installed and configured" "Status"
        return $true
    }

    Write-ColorOutput "Installing CLI tools..." "Status"
    
    # Install zoxide first
    try {
        if (-not (Test-Command "zoxide")) {
            Write-ColorOutput "Installing zoxide..." "Status"
            Invoke-SafeCommand { choco install zoxide -y } -ErrorMessage "Failed to install zoxide"
            RefreshPath
            
            if (-not (Test-Command "zoxide")) {
                throw "Zoxide installation failed verification"
            }
            Write-ColorOutput "Zoxide installed successfully" "Success"
        } else {
            Write-ColorOutput "Zoxide is already installed" "Status"
        }
        
        # Configure zoxide
        if (-not (Test-Path $PROFILE)) {
            New-Item -Path $PROFILE -ItemType File -Force | Out-Null
            Write-ColorOutput "Created new PowerShell profile" "Status"
        }
        
        if (-not (Select-String -Path $PROFILE -Pattern "zoxide init" -Quiet -ErrorAction SilentlyContinue)) {
            $zoxideConfig = @"

# Zoxide Configuration
Invoke-Expression (& {
    `$hook = if (`$PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook `$hook powershell | Out-String)
})
"@
            Add-Content -Path $PROFILE -Value $zoxideConfig
            Write-ColorOutput "Zoxide configuration added to profile" "Success"
        } else {
            Write-ColorOutput "Zoxide already configured in profile" "Status"
        }
    }
    catch {
        Write-ColorOutput "Failed to setup zoxide: $_" "Error"
        return $false
    }
    
    # PSFzf installation and configuration
    try {
        if (-not (Get-Module -ListAvailable -Name PSFzf)) {
            Write-ColorOutput "Installing PSFzf module..." "Status"
            Install-Module -Name PSFzf -Scope CurrentUser -Force
            Write-ColorOutput "PSFzf module installed" "Success"
            
            # Configure PSFzf
            if (-not (Select-String -Path $PROFILE -Pattern "PSFzf" -Quiet -ErrorAction SilentlyContinue)) {
                $fzfConfig = @"

# PSFzf Configuration
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
"@
                Add-Content -Path $PROFILE -Value $fzfConfig
                Write-ColorOutput "PSFzf configuration added to profile" "Success"
            } else {
                Write-ColorOutput "PSFzf already configured in profile" "Status"
            }
        } else {
            Write-ColorOutput "PSFzf module already installed" "Status"
        }
    }
    catch {
        Write-ColorOutput "Failed to setup PSFzf: $_" "Error"
        return $false
    }
    
    # Verify fzf is installed (required by PSFzf)
    try {
        if (-not (Test-Command "fzf")) {
            Write-ColorOutput "Installing fzf..." "Status"
            Invoke-SafeCommand { choco install fzf -y } -ErrorMessage "Failed to install fzf"
            RefreshPath
            
            if (-not (Test-Command "fzf")) {
                throw "fzf installation failed verification"
            }
            Write-ColorOutput "fzf installed successfully" "Success"
        } else {
            Write-ColorOutput "fzf is already installed" "Status"
        }
    }
    catch {
        Write-ColorOutput "Failed to setup fzf: $_" "Error"
        return $false
    }
    
    # Reload profile to apply changes
    try {
        Write-ColorOutput "Reloading PowerShell profile..." "Status"
        . $PROFILE
        Write-ColorOutput "PowerShell profile reloaded" "Success"
    }
    catch {
        Write-ColorOutput "Failed to reload PowerShell profile: $_" "Warn"
        Write-ColorOutput "You may need to restart your PowerShell session" "Warn"
    }
    
    Save-InstallationState "cli_tools"
    Write-ColorOutput "CLI tools configuration completed" "Success"
    return $true
}

# Function to install fonts
function Install-NerdFonts {
    Write-ColorOutput "Installing JetBrainsMono Nerd Font..." "Status"

    $fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip"
    $fontsFolder = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
    $downloadPath = "$env:TEMP\JetBrainsMono.zip"

    # Download and extract font
    Invoke-WebRequest -Uri $fontUrl -OutFile $downloadPath
    Expand-Archive -Path $downloadPath -DestinationPath "$env:TEMP\JetBrainsMono" -Force

    # Install fonts
    $fonts = Get-ChildItem -Path "$env:TEMP\JetBrainsMono" -Filter "*.ttf"
    foreach ($font in $fonts) {
        Copy-Item $font.FullName $fontsFolder
    }

    Write-ColorOutput "Fonts installed successfully" "Success"
}

# Function to install and configure Starship
function Install-Starship {
    if (Test-InstallationState "starship") {
        Write-ColorOutput "Starship already installed and configured" "Status"
        return $true
    }

    Write-ColorOutput "Installing and configuring Starship..." "Status"
    
    try {
        # Install Starship using Chocolatey
        choco install starship -y
        RefreshPath
        
        if (-not (Get-Command -Name starship -ErrorAction SilentlyContinue)) {
            Write-ColorOutput "Starship installation failed" "Error"
            return $false
        }
        
        # Create Starship config directory
        $starshipDir = "$env:USERPROFILE\.config"
        if (-not (Test-Path $starshipDir)) {
            New-Item -ItemType Directory -Path $starshipDir -Force | Out-Null
        }
        
        # Backup existing configuration
        $configPath = "$starshipDir\starship.toml"
        if (Test-Path $configPath) {
            Move-Item $configPath "$configPath.backup" -Force
        }
        
        # Clone dotfiles repository temporarily to get starship config
        $tempPath = "$env:TEMP\dotfiles"
        if (Test-Path $tempPath) {
            Remove-Item $tempPath -Recurse -Force
        }
        
        git clone https://github.com/JDLanctot/dotfiles.git $tempPath
        
        if (Test-Path "$tempPath\.config\starship.toml") {
            Copy-Item "$tempPath\.config\starship.toml" $configPath -Force
            Write-ColorOutput "Starship configuration installed" "Success"
        }
        else {
            Write-ColorOutput "starship.toml not found in dotfiles" "Error"
            return $false
        }
        
        # Update PowerShell profile
        if (-not (Test-Path $PROFILE)) {
            New-Item -path $PROFILE -type file -force | Out-Null
        }
        
        $profileContent = Get-Content $PROFILE -Raw
        $initCommand = 'Invoke-Expression (&starship init powershell)'
        
        if ($profileContent -notmatch [regex]::Escape($initCommand)) {
            Add-Content $PROFILE "`n$initCommand"
            Write-ColorOutput "Starship initialization added to PowerShell profile" "Success"
        }
        
        # Cleanup
        Remove-Item $tempPath -Recurse -Force
        
        Save-InstallationState "starship"
        Write-ColorOutput "Starship setup completed" "Success"
        return $true
    }
    catch {
        Write-ColorOutput "Failed to install/configure Starship: $_" "Error"
        return $false
    }
}

# Function to install and configure Neovim
function Install-Neovim {
    if (Test-InstallationState "neovim") {
        Write-ColorOutput "Neovim already installed and configured" "Status"
        return $true
    }

    Write-ColorOutput "Installing and configuring Neovim..." "Status"
    
    try {
        # Install Neovim
        choco install neovim -y
        RefreshPath
        
        if (-not (Get-Command -Name nvim -ErrorAction SilentlyContinue)) {
            Write-ColorOutput "Neovim installation failed" "Error"
            return $false
        }
        
        # Add Neovim to Path
        $neovimPath = "C:\tools\neovim\Neovim\bin"
        $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
        if ($userPath -notlike "*$neovimPath*") {
            [Environment]::SetEnvironmentVariable(
                "Path",
                "$userPath;$neovimPath",
                "User"
            )
        }
        
        # Configure Neovim
        $nvimConfigPath = "$env:LOCALAPPDATA\nvim"
        $nvimBackupPath = "$nvimConfigPath.backup"
        
        # Backup existing configuration
        if (Test-Path $nvimConfigPath) {
            if (Test-Path $nvimBackupPath) {
                Remove-Item $nvimBackupPath -Recurse -Force
            }
            Move-Item $nvimConfigPath $nvimBackupPath
        }

        # Clone dotfiles directly into nvim config directory
        Push-Location $env:LOCALAPPDATA
        try {
            git clone https://github.com/JDLanctot/dotfiles.git nvim
            Push-Location nvim
            try {
                # Move Neovim configuration files to root and clean up others
                if (Test-Path ".config\nvim") {
                    Move-Item .config\nvim\* . -Force
                    # Clean up unnecessary files and directories
                    Remove-Item .config -Recurse -Force
                    Remove-Item .zsh -Recurse -Force
                    Remove-Item .bashrc -Force
                    Remove-Item .zshrc -Force
                    Remove-Item .zshenv -Force
                    Remove-Item README.md -Force
                    Remove-Item .git -Recurse -Force
                    Remove-Item .julia -Recurse -Force -ErrorAction SilentlyContinue
                    
                    Write-ColorOutput "Neovim configuration installed" "Success"
                    
                    # Install plugins
                    Write-ColorOutput "Installing Neovim plugins (this may take a while)..." "Status"
                    $result = Start-Process -Wait -NoNewWindow nvim -ArgumentList "--headless", "+Lazy! sync", "+qa" -PassThru
                    
                    if ($result.ExitCode -ne 0) {
                        throw "Plugin installation failed"
                    }
                }
                else {
                    throw "Neovim configuration not found in dotfiles"
                }
            }
            finally {
                Pop-Location
            }
        }
        catch {
            # If anything fails, restore backup and clean up
            if (Test-Path $nvimConfigPath) {
                Remove-Item $nvimConfigPath -Recurse -Force
            }
            if (Test-Path $nvimBackupPath) {
                Move-Item $nvimBackupPath $nvimConfigPath
            }
            Write-ColorOutput "Failed during Neovim configuration: $_" "Error"
            return $false
        }
        finally {
            Pop-Location
        }
        
        # Remove backup if everything succeeded
        if (Test-Path $nvimBackupPath) {
            Remove-Item $nvimBackupPath -Recurse -Force
        }
        
        Save-InstallationState "neovim"
        Write-ColorOutput "Neovim setup completed" "Success"
        return $true
    }
    catch {
        Write-ColorOutput "Failed to install/configure Neovim: $_" "Error"
        return $false
    }
}

# Function to install Julia
function Install-Julia {
    if (Test-InstallationState "julia") {
        Write-ColorOutput "Julia already installed" "Status"
        return $true
    }

    Write-ColorOutput "Installing Julia..." "Status"
    
    # Install Julia using Chocolatey
    try {
        choco install julia -y
        RefreshPath
        
        if (-not (Get-Command -Name julia -ErrorAction SilentlyContinue)) {
            Write-ColorOutput "Julia installation failed" "Error"
            return $false
        }
        
        # Setup Julia configuration
        $juliaConfigPath = "$env:USERPROFILE\.julia\config"
        New-SafeDirectory -Path $juliaConfigPath
        
        # Copy startup.jl from dotfiles
        $tempPath = "$env:TEMP\dotfiles"
        if (-not (Test-Path "$juliaConfigPath\startup.jl")) {
            if (-not (Test-Path $tempPath)) {
                git clone https://github.com/JDLanctot/dotfiles.git $tempPath
            }
            
            if (Test-Path "$tempPath\.julia\config\startup.jl") {
                Copy-Item "$tempPath\.julia\config\startup.jl" $juliaConfigPath -Force
                Write-ColorOutput "Julia configuration installed" "Success"
            }
            else {
                Write-ColorOutput "Julia startup.jl not found in dotfiles" "Error"
            }
            
            # Cleanup
            if (Test-Path $tempPath) {
                Remove-Item $tempPath -Recurse -Force
            }
        }
        
        $juliaVersion = (julia --version)
        Write-ColorOutput "Julia $juliaVersion installed and configured" "Success"
        Save-InstallationState "julia"
        return $true
    }
    catch {
        Write-ColorOutput "Failed to install Julia: $_" "Error"
        return $false
    }
}

# Function to install Zig
function Install-Zig {
    if (Test-InstallationState "zig") {
        Write-ColorOutput "Zig already installed" "Status"
        return $true
    }

    Write-ColorOutput "Installing Zig..." "Status"
    
    try {
        # Install Zig using Chocolatey
        choco install zig -y
        RefreshPath
        
        if (-not (Get-Command -Name zig -ErrorAction SilentlyContinue)) {
            Write-ColorOutput "Zig installation failed" "Error"
            return $false
        }
        
        # Add Zig to Path if not already present
        $zigPath = "C:\ProgramData\chocolatey\bin"
        $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
        if ($userPath -notlike "*$zigPath*") {
            [Environment]::SetEnvironmentVariable(
                "Path",
                "$userPath;$zigPath",
                "User"
            )
        }
        
        $zigVersion = (zig version)
        Write-ColorOutput "Zig $zigVersion installed" "Success"
        Save-InstallationState "zig"
        return $true
    }
    catch {
        Write-ColorOutput "Failed to install Zig: $_" "Error"
        return $false
    }
}

# Function to install Node.js and pnpm
function Install-Node {
    if (Test-InstallationState "nodejs") {
        Write-ColorOutput "Node.js and pnpm already installed" "Status"
        return $true
    }

    Write-ColorOutput "Installing Node.js and pnpm..." "Status"
    
    # Install Node.js using Chocolatey
    if (-not (Get-Command -Name node -ErrorAction SilentlyContinue)) {
        try {
            choco install nodejs-lts -y
            RefreshPath
            
            if (-not (Get-Command -Name node -ErrorAction SilentlyContinue)) {
                Write-ColorOutput "Node.js installation failed" "Error"
                return $false
            }
            
            $nodeVersion = (node --version)
            Write-ColorOutput "Node.js $nodeVersion installed" "Success"
        }
        catch {
            Write-ColorOutput "Failed to install Node.js: $_" "Error"
            return $false
        }
    }
    else {
        $nodeVersion = (node --version)
        Write-ColorOutput "Node.js $nodeVersion is already installed" "Status"
    }
    
    # Install pnpm
    if (-not (Get-Command -Name pnpm -ErrorAction SilentlyContinue)) {
        try {
            npm install -g pnpm
            RefreshPath
            
            if (-not (Get-Command -Name pnpm -ErrorAction SilentlyContinue)) {
                Write-ColorOutput "pnpm installation failed" "Error"
                return $false
            }
            
            $pnpmVersion = (pnpm --version)
            Write-ColorOutput "pnpm $pnpmVersion installed" "Success"
        }
        catch {
            Write-ColorOutput "Failed to install pnpm: $_" "Error"
            return $false
        }
    }
    else {
        $pnpmVersion = (pnpm --version)
        Write-ColorOutput "pnpm $pnpmVersion is already installed" "Status"
    }
    
    Save-InstallationState "nodejs"
    Write-ColorOutput "Node.js environment setup completed" "Success"
    return $true
}

# Function to setup PowerShell profile
function Install-PowerShellProfile {
    if (Test-InstallationState "powershell_profile") {
        Write-ColorOutput "PowerShell profile already configured" "Status"
        return $true
    }

    Write-ColorOutput "Setting up PowerShell profile..." "Status"
    
    try {
        # Create profile directory if it doesn't exist
        $profileDir = Split-Path $PROFILE -Parent
        if (-not (Test-Path $profileDir)) {
            New-Item -Path $profileDir -ItemType Directory -Force | Out-Null
        }
        
        # Backup existing profile
        if (Test-Path $PROFILE) {
            Copy-Item $PROFILE "$PROFILE.backup" -Force
        }
        
        # Get profile from dotfiles
        $tempPath = "$env:TEMP\dotfiles"
        if (-not (Test-Path $tempPath)) {
            git clone https://github.com/JDLanctot/dotfiles.git $tempPath
        }
        
        if (Test-Path "$tempPath\.windows\profile.ps1") {
            Copy-Item "$tempPath\.windows\profile.ps1" $PROFILE -Force
            Write-ColorOutput "PowerShell profile installed" "Success"
            
            # Verify essential configurations
            $profileContent = Get-Content $PROFILE -Raw
            $requiredConfigs = @(
                @{Name = "Starship initialization"; Pattern = "Invoke-Expression \(&starship init powershell\)"}
                @{Name = "PSFzf import"; Pattern = "Import-Module PSFzf"}
                @{Name = "Neovim alias"; Pattern = "Set-Alias.*vim.*nvim"}
            )
            
            $missingConfigs = @()
            foreach ($config in $requiredConfigs) {
                if ($profileContent -notmatch $config.Pattern) {
                    $missingConfigs += $config.Name
                }
            }
            
            if ($missingConfigs.Count -gt 0) {
                Write-ColorOutput "Warning: Missing configurations in profile:" "Error"
                foreach ($config in $missingConfigs) {
                    Write-ColorOutput "- $config" "Error"
                }
                return $false
            }
            
            Write-ColorOutput "All essential configurations verified in profile" "Success"
        }
        else {
            Write-ColorOutput "PowerShell profile not found in dotfiles" "Error"
            return $false
        }
        
        Save-InstallationState "powershell_profile"
        Write-ColorOutput "PowerShell profile setup completed" "Success"
        return $true
    }
    catch {
        Write-ColorOutput "Failed to configure PowerShell profile: $_" "Error"
        if (Test-Path "$PROFILE.backup") {
            Move-Item "$PROFILE.backup" $PROFILE -Force
        }
        return $false
    }
    finally {
        # Cleanup
        if (Test-Path $tempPath) {
            Remove-Item $tempPath -Recurse -Force
        }
    }
}

# Get config files
# Consolidated Setup-Dotfiles function
function Setup-Dotfiles {
    if (Test-InstallationState "dotfiles") {
        Write-ColorOutput "Dotfiles already configured" "Status"
        return $true
    }

    Write-ColorOutput "Setting up dotfiles..." "Status"
    
    # Use Join-Path for consistent path handling
    $tempPath = Join-Path $env:TEMP "dotfiles"
    if (Test-Path $tempPath) {
        Remove-Item $tempPath -Recurse -Force
    }
    
    try {
        # Clone using HTTPS to avoid SSH issues during initial setup
        git clone https://github.com/JDLanctot/dotfiles.git $tempPath
        
        # Install each configuration using the defined paths
        foreach ($configName in $CONFIG_PATHS.Keys) {
            Write-ColorOutput "Installing ${configName} configuration..." "Status"
            if (-not (Install-Configuration -Name $configName -TempPath $tempPath)) {
                throw "Failed to install ${configName} configuration"
            }
        }
        
        Save-InstallationState "dotfiles"
        Write-ColorOutput "Dotfiles setup completed" "Success"
        return $true
    }
    catch {
        Write-ColorOutput "Failed to set up dotfiles: ${_}" "Error"
        return $false
    }
    finally {
        # Cleanup
        if (Test-Path $tempPath) {
            Remove-Item $tempPath -Recurse -Force
        }
    }
}

# Function to configure Conda for PowerShell
function Configure-Conda {
    Write-ColorOutput "Configuring Conda for PowerShell..." "Status"
    
    if (Get-Command conda -ErrorAction SilentlyContinue) {
        conda init powershell
        Write-ColorOutput "Conda configured for PowerShell successfully" "Success"
    } else {
        Write-ColorOutput "Conda not found. Please install Anaconda Navigator first" "Error"
    }
}

function Initialize-Configuration {
    Write-Log "Loading configuration..." -Level "INFO"
    
    $configPath = Join-Path $PSScriptRoot "config.psd1"
    if (-not (Test-Path $configPath)) {
        throw "Configuration file not found at: ${configPath}"
    }
    
    try {
        $script:Config = Import-PowerShellDataFile $configPath
        
        # Validate configuration
        if (-not $Config.Paths -or -not $Config.Programs) {
            throw "Invalid configuration file: missing required sections"
        }
        
        # Process paths and create fully qualified paths
        $processedPaths = @{}
        foreach ($key in $Config.Paths.Keys) {
            $pathConfig = $Config.Paths[$key]
            
            # Construct the target path based on the type
            $targetPath = switch ($key) {
                'nvim' { Join-Path $env:LOCALAPPDATA $pathConfig.target }
                'bat' { Join-Path $env:APPDATA $pathConfig.target }
                'powershell' { $PROFILE }
                default { Join-Path $env:USERPROFILE $pathConfig.target }
            }
            
            $processedPaths[$key] = @{
                'source' = $pathConfig.source
                'target' = $targetPath
                'type' = $pathConfig.type
            }
        }
        
        # Set CONFIG_PATHS for backward compatibility
        $script:CONFIG_PATHS = $processedPaths
        
        Write-Log "Configuration loaded successfully" -Level "SUCCESS"
    }
    catch {
        throw "Failed to load configuration: ${_}"
    }
}

function Show-Progress {
    param(
        [string]$Activity,
        [int]$PercentComplete,
        [string]$Status,
        [switch]$Completed
    )
    
    $params = @{
        Activity = $Activity
        Status = $Status
        PercentComplete = $PercentComplete
    }
    
    if ($Completed) {
        $params['Completed'] = $true
    }
    
    Write-Progress @params
}

function Show-Summary {
    param(
        [hashtable]$Results
    )
    
    $summary = @"
Installation Summary
-------------------
Total Steps: $($Results.Total)
Successful: $($Results.Successful)
Failed: $($Results.Failed)
Skipped: $($Results.Skipped)

Failed Steps:
$($Results.FailedSteps -join "`n")

Log File: ${SCRIPT_LOG_PATH}
"@
    
    Write-Host $summary
    Write-Log $summary -Level "INFO"
}

function Show-Checkpoint {
    param(
        [string]$Message,
        [switch]$Confirm
    )
    
    Write-Host "`n${Message}`n" -ForegroundColor Cyan
    
    if ($Confirm) {
        $response = Read-Host "Press Enter to continue or 'Q' to quit"
        if ($response -eq 'Q') {
            Write-Log "User cancelled installation at checkpoint: ${Message}" -Level "INFO"
            exit 0
        }
    }
}

function Set-WorkingDirectory {
    param (
        [string]$Path
    )
    try {
        Push-Location $Path
        return $true
    }
    catch {
        Write-ColorOutput "Failed to change directory to ${Path}" "Error"
        return $false
    }
}

function Reset-WorkingDirectory {
    Pop-Location
}

function New-SafeDirectory {
    param(
        [string]$Path,
        [switch]$Force
    )
    if (-not (Test-Path $Path)) {
        try {
            New-Item -ItemType Directory -Path $Path -Force:$Force -ErrorAction Stop
            Write-ColorOutput "Created directory: $Path" "Success"
        }
        catch {
            Write-ColorOutput "Failed to create directory: $Path - $_" "Error"
            return $false
        }
    }
    else {
        Write-ColorOutput "Directory already exists: $Path" "Status"
    }
    return $true
}

function RefreshPath {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + 
                [System.Environment]::GetEnvironmentVariable("Path","User")
}

function Write-Log {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [string]$Level = "INFO",
        [switch]$NoConsole
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "${timestamp} [${Level}] ${Message}"
    
    # Always write to log file
    Add-Content -Path $SCRIPT_LOG_PATH -Value $logMessage
    
    # Write to console if not suppressed
    if (-not $NoConsole) {
        $color = switch ($Level) {
            "ERROR" { "Red" }
            "WARN"  { "Yellow" }
            "SUCCESS" { "Green" }
            default { "White" }
        }
        Write-Host $logMessage -ForegroundColor $color
    }
}

# Replace Write-ColorOutput with enhanced version
function Write-ColorOutput {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [Parameter(Mandatory=$true)]
        [string]$Type
    )
    
    $level = switch ($Type) {
        "Error" { "ERROR" }
        "Success" { "SUCCESS" }
        "Status" { "INFO" }
        default { "INFO" }
    }
    
    Write-Log -Message $Message -Level $level
}


# Add error handling wrapper
function Invoke-SafeCommand {
    param(
        [Parameter(Mandatory=$true)]
        [scriptblock]$ScriptBlock,
        [string]$ErrorMessage,
        [switch]$ContinueOnError
    )
    
    try {
        $result = & $ScriptBlock
        if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) {
            throw "Command exited with code ${LASTEXITCODE}"
        }
        return $result
    }
    catch {
        $fullError = "${ErrorMessage}: ${_}"
        Write-Log -Message $fullError -Level "ERROR"
        if (-not $ContinueOnError) {
            throw $_
        }
        return $false
    }
}

function Backup-InstallationState {
    param(
        [string]$StepName,
        [string]$Path
    )
    
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupPath = "${Path}.backup_${timestamp}"
    
    try {
        if (Test-Path $Path) {
            if (Test-Path $backupPath) {
                Remove-Item $backupPath -Recurse -Force
            }
            
            Copy-Item -Path $Path -Destination $backupPath -Recurse -Force
            $INSTALLATION_STATE.Steps[$StepName].BackupPaths += @{
                Original = $Path
                Backup = $backupPath
            }
            Write-Log "Created backup: ${backupPath}" -Level "SUCCESS"
            return $backupPath
        }
    }
    catch {
        Write-Log "Failed to create backup for ${Path}: ${_}" -Level "ERROR"
        return $null
    }
}

function Restore-InstallationState {
    param(
        [string]$StepName
    )
    
    $step = $INSTALLATION_STATE.Steps[$StepName]
    if (-not $step) {
        Write-Log "No installation state found for step: ${StepName}" -Level "ERROR"
        return $false
    }
    
    $success = $true
    foreach ($backup in $step.BackupPaths) {
        try {
            if (Test-Path $backup.Backup) {
                if (Test-Path $backup.Original) {
                    Remove-Item $backup.Original -Recurse -Force
                }
                Copy-Item -Path $backup.Backup -Destination $backup.Original -Recurse -Force
                Write-Log "Restored ${backup.Original} from backup" -Level "SUCCESS"
            }
            else {
                Write-Log "Backup not found: ${backup.Backup}" -Level "ERROR"
                $success = $false
            }
        }
        catch {
            Write-Log "Failed to restore ${backup.Original}: ${_}" -Level "ERROR"
            $success = $false
        }
    }
    return $success
}

# Check if a component is already installed
function Save-InstallationState {
    param([string]$Component)
    $INSTALLED_COMPONENTS[$Component] = $true
    Add-Content -Path "$env:USERPROFILE\.dotfiles_installed" -Value $Component
}

function Test-InstallationState {
    param([string]$Component)
    if (Test-Path "$env:USERPROFILE\.dotfiles_installed") {
        return (Get-Content "$env:USERPROFILE\.dotfiles_installed" | Select-String "^$Component$")
    }
    return $false
}

function Test-Dependencies {
    param(
        [string[]]$RequiredModules,
        [hashtable]$RequiredCommands
    )
    
    $missing = @()
    
    foreach ($module in $RequiredModules) {
        if (-not (Get-Module -ListAvailable -Name $module)) {
            $missing += "Module: ${module}"
        }
    }
    
    foreach ($command in $RequiredCommands.Keys) {
        if (-not (Get-Command -Name $command -ErrorAction SilentlyContinue)) {
            $version = $RequiredCommands[$command]
            $missing += "Command: ${command} (Required version: ${version})"
        }
    }
    
    if ($missing.Count -gt 0) {
        Write-Log "Missing dependencies:`n$($missing -join "`n")" -Level "ERROR"
        return $false
    }
    
    return $true
}

function Test-RequiredPrograms {
    $missing = @()
    foreach ($program in $Config.Programs.Where({$_.Required})) {
        if (-not (Get-Command -Name $program.Alias -ErrorAction SilentlyContinue)) {
            $missing += $program.Name
        }
    }
    
    return $missing
}

# Function to check if a command exists
function Test-Command {
    param($Command)
    return [bool](Get-Command -Name $Command -ErrorAction SilentlyContinue)
}

function Test-SystemRequirements {
    Write-Log "Checking system requirements..." -Level "INFO"

    $checks = @(
        @{
            Name = "PowerShell Version"
            Check = {
                $currentVersion = $PSVersionTable.PSVersion.ToString()
                Write-Log "Current PowerShell version: ${currentVersion}" -Level "INFO"
                
                if (-not (Test-Version -Current $currentVersion -Required $Config.MinimumRequirements.PSVersion)) {
                    throw "PowerShell version ${currentVersion} is below minimum required version $($Config.MinimumRequirements.PSVersion)"
                }
                return $true
            }
        }
        @{
            Name = "Windows Version"
            Check = {
                $osVersion = [System.Environment]::OSVersion.Version.ToString()
                Write-Log "Current Windows version: ${osVersion}" -Level "INFO"
                
                if (-not (Test-Version -Current $osVersion -Required $Config.MinimumRequirements.WindowsVersion)) {
                    throw "Windows version ${osVersion} is below minimum required version $($Config.MinimumRequirements.WindowsVersion)"
                }
                return $true
            }
        }
        @{
            Name = "Available Disk Space"
            Check = {
                $systemDrive = $env:SystemDrive[0]
                $freeSpace = (Get-PSDrive $systemDrive).Free / 1GB
                Write-Log "Available disk space: ${freeSpace}GB" -Level "INFO"
                
                if ($freeSpace -lt $Config.MinimumRequirements.RequiredDiskSpaceGB) {
                    throw "Insufficient disk space. Required: $($Config.MinimumRequirements.RequiredDiskSpaceGB)GB, Available: ${freeSpace}GB"
                }
                return $true
            }
        }
        @{
            Name = "Administrator Privileges"
            Check = {
                $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
                Write-Log "Running with administrator privileges: $isAdmin" -Level "INFO"
                
                if (-not $isAdmin) {
                    throw "Script must be run with administrator privileges"
                }
                return $true
            }
        }
        @{
            Name = "Internet Connectivity"
            Check = {
                $testConnection = Test-NetConnection -ComputerName "github.com" -Port 443 -WarningAction SilentlyContinue
                Write-Log "Internet connectivity to GitHub: $($testConnection.TcpTestSucceeded)" -Level "INFO"
                
                if (-not $testConnection.TcpTestSucceeded) {
                    throw "No internet connection or GitHub is unreachable"
                }
                return $true
            }
        }
        @{
            Name = "TLS 1.2 Support"
            Check = {
                $currentProtocol = [System.Net.ServicePointManager]::SecurityProtocol
                Write-Log "Current security protocol: $currentProtocol" -Level "INFO"
                
                if (-not ($currentProtocol -band [System.Net.SecurityProtocolType]::Tls12)) {
                    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12
                    Write-Log "Enabled TLS 1.2 support" -Level "INFO"
                }
                return $true
            }
        }
        @{
            Name = "PowerShell Script Execution Policy"
            Check = {
                $executionPolicy = Get-ExecutionPolicy
                Write-Log "Current execution policy: $executionPolicy" -Level "INFO"
                
                if ($executionPolicy -eq "Restricted") {
                    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
                    Write-Log "Set execution policy to Bypass for current process" -Level "INFO"
                }
                return $true
            }
        }
    )

    $allPassed = $true
    foreach ($check in $checks) {
        Write-Log "Running check: $($check.Name)" -Level "INFO"
        try {
            $result = Invoke-SafeCommand -ScriptBlock $check.Check -ErrorMessage "Failed $($check.Name) check"
            if ($result) {
                Write-Log "$($check.Name) check passed" -Level "SUCCESS"
            }
            else {
                $allPassed = $false
                Write-Log "$($check.Name) check failed" -Level "ERROR"
            }
        }
        catch {
            $allPassed = $false
            Write-Log "$($check.Name) check failed: $_" -Level "ERROR"
            if ($check.Name -in @("Administrator Privileges", "PowerShell Version", "Windows Version")) {
                Write-Log "This is a critical requirement. Installation cannot continue." -Level "ERROR"
                return $false
            }
        }
    }

    if ($allPassed) {
        Write-Log "All system requirement checks passed" -Level "SUCCESS"
    }
    else {
        Write-Log "Some system requirements checks failed" -Level "WARN"
    }

    return $allPassed
}

function Test-Version {
    param (
        [string]$Current,
        [string]$Required
    )
    return ([System.Version]$Current -ge [System.Version]$Required)
}

function Verify-Installation {
    param(
        [string]$Component,
        [scriptblock]$VerificationScript
    )
    
    Write-Log "Verifying ${Component} installation..." -Level "INFO"
    
    try {
        $result = & $VerificationScript
        if ($result) {
            Write-Log "${Component} verification successful" -Level "SUCCESS"
            return $true
        } else {
            Write-Log "${Component} verification failed" -Level "ERROR"
            return $false
        }
    }
    catch {
        Write-Log "Error verifying ${Component}: ${_}" -Level "ERROR"
        return $false
    }
}

function Install-Configuration {
    param(
        [string]$Name,
        [string]$TempPath
    )
    
    if (-not $CONFIG_PATHS.ContainsKey($Name)) {
        Write-ColorOutput "Unknown configuration: ${Name}" "Error"
        return $false
    }
    
    $config = $CONFIG_PATHS[$Name]
    $sourcePath = Join-Path $TempPath $config.source
    $targetPath = $config.target
    
    # Create target directory if it doesn't exist
    $targetDir = Split-Path $targetPath -Parent
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }
    
    # Backup existing configuration
    $backupPath = Backup-Configuration -Path $targetPath -Type $config.type
    
    try {
        if (Test-Path $sourcePath) {
            if ($config.type -eq 'directory') {
                if (Test-Path $targetPath) {
                    Remove-Item $targetPath -Recurse -Force
                }
                Copy-Item $sourcePath $targetPath -Recurse -Force
            } else {
                Copy-Item $sourcePath $targetPath -Force
            }
            Write-ColorOutput "${Name} configuration installed" "Success"
            return $true
        } else {
            Write-ColorOutput "${Name} configuration not found in dotfiles" "Error"
            if ($backupPath) {
                Restore-Configuration -BackupPath $backupPath -TargetPath $targetPath -Type $config.type
            }
            return $false
        }
    }
    catch {
        Write-ColorOutput "Failed to install ${Name} configuration: ${_}" "Error"
        if ($backupPath) {
            Restore-Configuration -BackupPath $backupPath -TargetPath $targetPath -Type $config.type
        }
        return $false
    }
}

function Remove-Installation {
    param(
        [switch]$KeepConfigs,
        [switch]$Force
    )
    
    if (-not $Force) {
        $response = Read-Host "This will remove all installed components. Are you sure? (Y/N)"
        if ($response -ne 'Y') {
            Write-Log "Uninstallation cancelled by user" -Level "INFO"
            return
        }
    }
    
    $components = Get-Content "$env:USERPROFILE\.dotfiles_installed" -ErrorAction SilentlyContinue
    
    foreach ($component in $components) {
        Write-Log "Removing ${component}..." -Level "INFO"
        
        # Restore original configurations if they exist
        if (-not $KeepConfigs) {
            $backups = Get-ChildItem -Path "$env:USERPROFILE" -Filter "*.backup_*" -Recurse
            foreach ($backup in $backups) {
                $original = $backup.FullName -replace '\.backup_.*$', ''
                if (Test-Path $original) {
                    Remove-Item $original -Recurse -Force
                }
                Move-Item $backup.FullName $original -Force
            }
        }
    }
    
    # Remove installation state file
    Remove-Item "$env:USERPROFILE\.dotfiles_installed" -Force -ErrorAction SilentlyContinue
    
    Write-Log "Uninstallation completed" -Level "SUCCESS"
}

function Start-Cleanup {
    param(
        [switch]$RemoveBackups,
        [switch]$RemoveLogs
    )
    
    if ($RemoveBackups) {
        Get-ChildItem -Path "$env:USERPROFILE" -Filter "*.backup_*" -Recurse | 
        ForEach-Object {
            Remove-Item $_.FullName -Force
            Write-Log "Removed backup: $($_.FullName)" -Level "INFO"
        }
    }
    
    if ($RemoveLogs) {
        Get-ChildItem -Path $env:TEMP -Filter "windows_setup_*.log" | 
        ForEach-Object {
            Remove-Item $_.FullName -Force
            Write-Log "Removed log file: $($_.FullName)" -Level "INFO"
        }
    }
    
    # Clean up temporary files
    Get-ChildItem -Path $env:TEMP -Filter "dotfiles*" -Directory | 
    ForEach-Object {
        Remove-Item $_.FullName -Recurse -Force
        Write-Log "Removed temporary directory: $($_.FullName)" -Level "INFO"
    }
}

function Start-InstallationStep {
    param(
        [string]$StepName,
        [scriptblock]$Action
    )
    
    $INSTALLATION_STATE.Steps[$StepName] = @{
        Status = "Running"
        StartTime = Get-Date
        BackupPaths = @()
    }
    
    try {
        & $Action
        $INSTALLATION_STATE.Steps[$StepName].Status = "Completed"
        return $true
    }
    catch {
        $INSTALLATION_STATE.Steps[$StepName].Status = "Failed"
        $INSTALLATION_STATE.Steps[$StepName].Error = $_
        return $false
    }
}

# Main installation function
function Start-Installation {
    [CmdletBinding()]
    param(
        [ValidateSet('Minimal', 'Standard', 'Full')]
        [string]$InstallationType = 'Standard',
        
        [switch]$Force,
        [switch]$NoBackup,
        [switch]$Silent
    )

    try {
        $INSTALLATION_STATE.StartTime = Get-Date
        $results = @{
            Total = 0
            Successful = 0
            Failed = 0
            Skipped = 0
            FailedSteps = @()
        }

        # Initialize logging and configuration
        Write-Log "Starting Windows setup (Type: ${InstallationType})" -Level "INFO"
        
        # Load and validate configuration
        Show-Progress -Activity "Initializing" -Status "Loading configuration..." -PercentComplete 0
        Initialize-Configuration
        
        # Check system requirements
        Show-Progress -Activity "Checking Requirements" -Status "Verifying system requirements..." -PercentComplete 5
        if (-not (Test-SystemRequirements)) {
            throw "System requirements not met. Please check the log file at ${SCRIPT_LOG_PATH}"
        }

        # Verify administrator privileges
        $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        if (-not $isAdmin) {
            throw "Administrator privileges required"
        }

        # Set working directory
        if (-not (Set-WorkingDirectory -Path $SCRIPT_DIR)) {
            throw "Failed to set working directory"
        }

        # Check dependencies
        Show-Progress -Activity "Checking Dependencies" -Status "Verifying required dependencies..." -PercentComplete 10
        if (-not (Test-Dependencies -RequiredModules @() -RequiredCommands @{})) {
            Show-Checkpoint -Message "Some dependencies are missing. Would you like to continue anyway?" -Confirm
        }

        # Define installation steps based on installation type
        $installationSteps = switch ($InstallationType) {
            'Minimal' {
                @(
                    @{ Name = "Chocolatey"; Function = { Install-Chocolatey }; Required = $true }
                    @{ Name = "Basic Programs"; Function = { Install-BasicPrograms }; Required = $true }
                    @{ Name = "PowerShell Profile"; Function = { Install-PowerShellProfile }; Required = $true }
                )
            }
            'Full' {
                @(
                    @{ Name = "Chocolatey"; Function = { Install-Chocolatey }; Required = $true }
                    @{ Name = "Basic Programs"; Function = { Install-BasicPrograms }; Required = $true }
                    @{ Name = "Git and SSH Setup"; Function = { Install-GitSSH }; Required = $true }
                    @{ Name = "Dotfiles"; Function = { Setup-Dotfiles }; Required = $true }
                    @{ Name = "CLI Tools"; Function = { Install-CliTools }; Required = $false }
                    @{ Name = "Nerd Fonts"; Function = { Install-NerdFonts }; Required = $false }
                    @{ Name = "Starship"; Function = { Install-Starship }; Required = $true }
                    @{ Name = "PowerShell Profile"; Function = { Install-PowerShellProfile }; Required = $true }
                    @{ Name = "Neovim"; Function = { Install-Neovim }; Required = $false }
                    @{ Name = "Node.js and pnpm"; Function = { Install-Node }; Required = $false }
                    @{ Name = "Julia"; Function = { Install-Julia }; Required = $false }
                    @{ Name = "Zig"; Function = { Install-Zig }; Required = $false }
                )
            }
            default { # Standard installation
                @(
                    @{ Name = "Chocolatey"; Function = { Install-Chocolatey }; Required = $true }
                    @{ Name = "Basic Programs"; Function = { Install-BasicPrograms }; Required = $true }
                    @{ Name = "Git and SSH Setup"; Function = { Install-GitSSH }; Required = $true }
                    @{ Name = "Dotfiles"; Function = { Setup-Dotfiles }; Required = $true }
                    @{ Name = "CLI Tools"; Function = { Install-CliTools }; Required = $true }
                    @{ Name = "Starship"; Function = { Install-Starship }; Required = $true }
                    @{ Name = "PowerShell Profile"; Function = { Install-PowerShellProfile }; Required = $true }
                    @{ Name = "Neovim"; Function = { Install-Neovim }; Required = $false }
                )
            }
        }

        $results.Total = $installationSteps.Count
        $stepNumber = 0

        # Execute installation steps
        foreach ($step in $installationSteps) {
            $stepNumber++
            $percentComplete = [math]::Floor(($stepNumber / $installationSteps.Count) * 100)
            
            Show-Progress -Activity "Installing $($step.Name)" -Status "Step $stepNumber of $($installationSteps.Count)" -PercentComplete $percentComplete
            
            Write-Log "Starting step: $($step.Name)" -Level "INFO"
            
            try {
                if (-not $Silent) {
                    Show-Checkpoint -Message "Starting installation of $($step.Name)" -Confirm:(-not $Force)
                }

                $success = Start-InstallationStep -StepName $step.Name -Action $step.Function
                
                if ($success) {
                    $results.Successful++
                    Write-Log "$($step.Name) completed successfully" -Level "SUCCESS"
                }
                else {
                    if ($step.Required) {
                        $results.Failed++
                        $results.FailedSteps += $step.Name
                        Write-Log "$($step.Name) failed" -Level "ERROR"
                        if (-not $Force) {
                            throw "Required step $($step.Name) failed"
                        }
                    }
                    else {
                        $results.Skipped++
                        Write-Log "$($step.Name) skipped due to failure" -Level "WARN"
                    }
                }

                # Verify installation if verification script exists
                if ($success) {
                    $verificationScript = Get-Variable -Name "Verify$($step.Name.Replace(' ',''))" -ErrorAction SilentlyContinue
                    if ($verificationScript) {
                        if (-not (Verify-Installation -Component $step.Name -VerificationScript $verificationScript.Value)) {
                            Write-Log "Verification failed for $($step.Name)" -Level "WARN"
                        }
                    }
                }
            }
            catch {
                $results.Failed++
                $results.FailedSteps += $step.Name
                Write-Log "Error during $($step.Name): $_" -Level "ERROR"
                
                if ($step.Required -and -not $Force) {
                    throw "Required step $($step.Name) failed: $_"
                }
            }
        }

        # Optional Conda configuration
        if ((Get-Command conda -ErrorAction SilentlyContinue) -and -not $Silent) {
            Write-Log "Configuring Conda..." -Level "INFO"
            Configure-Conda
        }

        # Show completion progress
        Show-Progress -Activity "Installation Complete" -Status "Finished" -PercentComplete 100 -Completed

        # Display summary
        Show-Summary -Results $results

        if ($results.Failed -gt 0) {
            Write-Log "Installation completed with $($results.Failed) failed steps" -Level "WARN"
            if (-not $Silent) {
                Start-Cleanup -RemoveBackups:$NoBackup
            }
        }
        else {
            Write-Log "Installation completed successfully" -Level "SUCCESS"
            if (-not $Silent) {
                Write-Log "Please restart your terminal to apply all changes" -Level "INFO"
            }
        }

        return $results
    }
    catch {
        Write-Log "Installation failed: $_" -Level "ERROR"
        Show-Progress -Activity "Installation Failed" -Status "Error" -PercentComplete 100 -Completed
        throw
    }
    finally {
        Reset-WorkingDirectory
        if (-not $Silent) {
            Show-Summary -Results $results
        }
    }
}

# Run the script
Start-Installation
