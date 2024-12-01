function Install-Alacritty {
    [CmdletBinding()]
    param()

    $didInstallSomething = $false

    try {
        Write-ColorOutput "Checking Alacritty installation..." "Status"

        if (Test-InstallationState "Alacritty") {
            Write-ColorOutput "Alacritty already installed" "Status"
            return $false
        }

        Write-ColorOutput "Installing Alacritty..." "Status"

        # Install Alacritty if not present
        if (-not (Get-Command -Name alacritty -ErrorAction SilentlyContinue)) {
            # Check if Alacritty is installed via MSI
            $msiPath = @(
                "${env:ProgramFiles}\Alacritty\alacritty.exe",
                "${env:LocalAppData}\Programs\Alacritty\alacritty.exe"
            )
            
            $installed = $false
            foreach ($path in $msiPath) {
                if (Test-Path $path) {
                    $installed = $true
                    # Add to PATH if not already there
                    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
                    $alacrittyDir = Split-Path $path -Parent
                    if ($userPath -notlike "*$alacrittyDir*") {
                        [Environment]::SetEnvironmentVariable(
                            "Path",
                            "$userPath;$alacrittyDir",
                            "User"
                        )
                        RefreshPath
                        $didInstallSomething = $true
                    }
                    break
                }
            }

            if (-not $installed) {
                Invoke-SafeCommand {
                    choco install alacritty -y
                } -ErrorMessage "Failed to install Alacritty"
                
                RefreshPath
                $didInstallSomething = $true

                if (-not (Get-Command -Name alacritty -ErrorAction SilentlyContinue)) {
                    throw "Alacritty installation verification failed"
                }
            }
        }

        # Create config directory (config files will be handled by Initialize-Dotfiles)
        $alacrittyConfigPath = "$env:USERPROFILE\AppData\Roaming\alacritty"
        if (-not (Test-Path $alacrittyConfigPath)) {
            New-SafeDirectory -Path $alacrittyConfigPath
            $didInstallSomething = $true
        }

        if ($didInstallSomething) {
            Write-ColorOutput "Alacritty installed" "Success"
            Save-InstallationState "Alacritty"
        }
        else {
            Write-ColorOutput "Alacritty was already installed" "Status"
        }

        return $didInstallSomething
    }
    catch {
        Handle-Error -ErrorRecord $_ `
            -ComponentName "Alacritty" `
            -Operation "Installation" `
            -Critical
        throw
    }
}
