function Install-Neovim {
    if (Test-InstallationState "Neovim") {
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

        # Remove backup if everything succeeded
        if (Test-Path $nvimBackupPath) {
            Remove-Item $nvimBackupPath -Recurse -Force
        }

        Save-InstallationState "Neovim"
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