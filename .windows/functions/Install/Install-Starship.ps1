function Install-Starship {
    [CmdletBinding()]
    param()
    
    $didInstallSomething = $false

    try {
        Write-ColorOutput "Checking Starship installation..." "Status"

        if (Test-InstallationState "starship") {
            Write-ColorOutput "Starship is already installed and configured" "Status"
            return $false
        }

        Write-ColorOutput "Installing and configuring Starship..." "Status"

        # Install Starship if not present
        if (-not (Get-Command -Name starship -ErrorAction SilentlyContinue)) {
            choco install starship -y
            RefreshPath
            $didInstallSomething = $true

            if (-not (Get-Command -Name starship -ErrorAction SilentlyContinue)) {
                throw "Starship installation failed"
            }
        }

        # Create Starship config directory
        $starshipDir = "$env:USERPROFILE\.starship"
        if (-not (Test-Path $starshipDir)) {
            New-Item -ItemType Directory -Path $starshipDir -Force | Out-Null
            $didInstallSomething = $true
        }

        # Backup existing configuration if it exists
        $configPath = "$starshipDir\starship.toml"
        if (Test-Path $configPath) {
            Move-Item $configPath "$configPath.backup" -Force
        }

        # Clone dotfiles repository temporarily to get starship config
        $tempPath = "$env:TEMP\dotfiles"
        if (Test-Path $tempPath) {
            Remove-Item $tempPath -Recurse -Force
        }

        try {
            git clone https://github.com/JDLanctot/dotfiles.git $tempPath

            if (Test-Path "$tempPath\.config\starship.toml") {
                Copy-Item "$tempPath\.config\starship.toml" $configPath -Force
                Write-ColorOutput "Starship configuration installed" "Success"
                $didInstallSomething = $true
            }
            else {
                throw "starship.toml not found in dotfiles"
            }
        }
        finally {
            # Cleanup
            if (Test-Path $tempPath) {
                Remove-Item $tempPath -Recurse -Force
            }
        }

        # Update PowerShell profile if needed
        if (-not (Test-Path $PROFILE)) {
            New-Item -Path $PROFILE -Type File -Force | Out-Null
            $didInstallSomething = $true
        }

        $initCommand = 'Invoke-Expression (&starship init powershell)'
        $profileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue

        if (-not ($profileContent -match [regex]::Escape($initCommand))) {
            Add-Content $PROFILE "`n$initCommand"
            Write-ColorOutput "Starship initialization added to PowerShell profile" "Success"
            $didInstallSomething = $true
        }

        if ($didInstallSomething) {
            Save-InstallationState "starship"
            Write-ColorOutput "Starship setup completed" "Success"
        }
        else {
            Write-ColorOutput "Starship was already set up, no changes needed" "Status"
        }

        return $didInstallSomething
    }
    catch {
        # Restore backup if it exists
        if (Test-Path "$configPath.backup") {
            Move-Item "$configPath.backup" $configPath -Force
        }
        
        Handle-Error -ErrorRecord $_ `
            -ComponentName "Starship" `
            -Operation "Installation" `
            -Critical
        throw
    }
}