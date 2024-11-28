function Install-Julia {
    [CmdletBinding()]
    param()

    $didInstallSomething = $false

    try {
        Write-ColorOutput "Checking Julia installation..." "Status"

        if (Test-InstallationState "julia") {
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

        # Setup Julia configuration
        $juliaConfigPath = "$env:USERPROFILE\.julia\config"
        if (-not (Test-Path $juliaConfigPath)) {
            New-SafeDirectory -Path $juliaConfigPath
            $didInstallSomething = $true
        }

        # Get and copy startup.jl from dotfiles
        $startupPath = "$juliaConfigPath\startup.jl"
        if (-not (Test-Path $startupPath)) {
            $tempPath = "$env:TEMP\dotfiles"
            
            try {
                if (Test-Path $tempPath) {
                    Remove-Item $tempPath -Recurse -Force
                }
                
                git clone https://github.com/JDLanctot/dotfiles.git $tempPath

                if (Test-Path "$tempPath\.julia\config\startup.jl") {
                    Copy-Item "$tempPath\.julia\config\startup.jl" $juliaConfigPath -Force
                    Write-ColorOutput "Julia configuration installed" "Success"
                    $didInstallSomething = $true
                }
                else {
                    Write-ColorOutput "Julia startup.jl not found in dotfiles" "Warn"
                }
            }
            finally {
                if (Test-Path $tempPath) {
                    Remove-Item $tempPath -Recurse -Force
                }
            }
        }

        if ($didInstallSomething) {
            $juliaVersion = (julia --version)
            Write-ColorOutput "Julia $juliaVersion installed and configured" "Success"
            Save-InstallationState "julia"
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