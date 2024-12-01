function Install-Julia {
    [CmdletBinding()]
    param()

    $didInstallSomething = $false

    try {
        Write-ColorOutput "Checking Julia installation..." "Status"

        if (Test-InstallationState "Julia") {
            Write-ColorOutput "Julia already installed and configured" "Status"
            return $false
        }

        Write-ColorOutput "Installing Julia..." "Status"

        # Install Julia if not present
        if (-not (Get-Command -Name julia -ErrorAction SilentlyContinue)) {
            Invoke-SafeCommand {
                choco install julia -y
            } -ErrorMessage "Failed to install Julia"
            
            RefreshPath
            $didInstallSomething = $true

            if (-not (Get-Command -Name julia -ErrorAction SilentlyContinue)) {
                throw "Julia installation verification failed"
            }
        }

        if ($didInstallSomething) {
            $juliaVersion = (julia --version)
            Write-ColorOutput "Julia $juliaVersion installed and configured" "Success"
            Save-InstallationState "Julia"
        }
        else {
            Write-ColorOutput "Julia was already installed and configured" "Status"
        }

        return $didInstallSomething
    }
    catch {
        # Restore backup if it exists
        if (Test-Path "$configPath.backup") {
            Move-Item "$configPath.backup" $configPath -Force
        }
          
        Handle-Error -ErrorRecord $_ `
            -ComponentName "Julia" `
            -Operation "Installation" `
            -Critical
        throw
    }
}