function Install-Neovim {
    if (Test-InstallationState "neovim") {
        Write-ColorOutput "Neovim already installed and configured" "Status"
        return $false  # Changed to false to indicate skip
    }

    Write-ColorOutput "Installing and configuring Neovim..." "Status"
    $didInstallSomething = $false

    try {
        # Check if Neovim is already installed
        if (-not (Get-Command -Name nvim -ErrorAction SilentlyContinue)) {
            # Install Neovim
            choco install neovim -y
            RefreshPath
            $didInstallSomething = $true

            if (-not (Get-Command -Name nvim -ErrorAction SilentlyContinue)) {
                throw "Neovim installation failed"
            }
        }

        # Add Neovim to Path if not already there
        $neovimPath = "C:\tools\neovim\Neovim\bin"
        $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
        if ($userPath -notlike "*$neovimPath*") {
            [Environment]::SetEnvironmentVariable(
                "Path",
                "$userPath;$neovimPath",
                "User"
            )
            $didInstallSomething = $true
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
                    $didInstallSomething = $true

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
            throw  # Changed to throw instead of return false
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
        return $didInstallSomething  # Return true only if we installed something new
    }
    catch {
        # Restore backup if it exists
        if (Test-Path "$configPath.backup") {
            Move-Item "$configPath.backup" $configPath -Force
        }
        
        Handle-Error -ErrorRecord $_ `
            -ComponentName "Neovim" `
            -Operation "Installation" `
            -Critical
        throw
    }
}