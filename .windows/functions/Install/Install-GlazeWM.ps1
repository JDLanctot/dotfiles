function Install-GlazeWM {
    [CmdletBinding()]
    param()

    $didInstallSomething = $false

    try {
        Write-ColorOutput "Checking GlazeWM installation..." "Status"

        if (Test-InstallationState "GlazeWM") {
            Write-ColorOutput "GlazeWM already installed" "Status"
            return $false
        }

        Write-ColorOutput "Installing GlazeWM..." "Status"

        # Install GlazeWM if not present
        if (-not (Get-Command -Name glazewm -ErrorAction SilentlyContinue)) {
            Invoke-SafeCommand {
                winget install GlazeWM
            } -ErrorMessage "Failed to install GlazeWM"
            
            RefreshPath
            $didInstallSomething = $true

            if (-not (Get-Command -Name glazewm -ErrorAction SilentlyContinue)) {
                throw "GlazeWM installation verification failed"
            }
        }

        # Create config directory (config files will be handled by Initialize-Dotfiles)
        $glazeConfigPath = "$env:USERPROFILE\.glzr\glazewm"
        if (-not (Test-Path $glazeConfigPath)) {
            New-SafeDirectory -Path $glazeConfigPath
            $didInstallSomething = $true
        }

        if ($didInstallSomething) {
            Write-ColorOutput "GlazeWM installed" "Success"
            Save-InstallationState "GlazeWM"
        }
        else {
            Write-ColorOutput "GlazeWM was already installed" "Status"
        }

        return $didInstallSomething
    }
    catch {
        Handle-Error -ErrorRecord $_ `
            -ComponentName "GlazeWM" `
            -Operation "Installation" `
            -Critical
        throw
    }
}