function Install-Starship {
    [CmdletBinding()]
    param()
    
    $didInstallSomething = $false

    try {
        Write-ColorOutput "Checking Starship installation..." "Status"

        if (Test-InstallationState "Starship") {
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