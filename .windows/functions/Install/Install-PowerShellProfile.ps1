function Install-PowerShellProfile {
    [CmdletBinding()]
    param()

    $didInstallSomething = $false

    try {
        Write-ColorOutput "Checking PowerShell profile..." "Status"

        # Get profile from dotfiles first to compare
        $tempPath = "$env:TEMP\dotfiles"
        if (Test-Path $tempPath) {
            Remove-Item $tempPath -Recurse -Force
        }

        try {
            Write-ColorOutput "Cloning dotfiles to: $tempPath" "Status"
            $cloneOutput = git clone https://github.com/JDLanctot/dotfiles.git $tempPath 2>&1
            if (-not (Test-Path $tempPath)) {
                Write-ColorOutput "Git clone failed to create directory: $cloneOutput" "Error"
                throw "Git clone failed: Directory not created"
            }

            $profileSource = Join-Path $tempPath ".windows" "config" "profile.ps1"
            Write-ColorOutput "Looking for profile at: $profileSource" "Status"

            if (-not (Test-Path $profileSource)) {
                throw "PowerShell profile not found at expected path: $profileSource"
            }

            # Only proceed if profile doesn't exist or is different
            if (Test-Path $PROFILE) {
                $sourceContent = Get-Content $profileSource -Raw
                $targetContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue

                if ($sourceContent -eq $targetContent) {
                    Write-ColorOutput "PowerShell profile is already up to date" "Status"
                    return $false
                }
            }

            # Create profile directory if needed
            $profileDir = Split-Path $PROFILE -Parent
            if (-not (Test-Path $profileDir)) {
                New-Item -Path $profileDir -ItemType Directory -Force | Out-Null
                $didInstallSomething = $true
            }

            # Try to copy new profile
            try {
                Copy-Item $profileSource $PROFILE -Force
                $didInstallSomething = $true
                Write-ColorOutput "PowerShell profile installed" "Success"
            }
            catch {
                Write-ColorOutput "Failed to update profile: $_" "Error"
                return $false
            }

            if ($didInstallSomething) {
                Save-InstallationState "powershell_profile"
                Write-ColorOutput "PowerShell profile setup completed" "Success"
            }

            return $didInstallSomething
        }
        finally {
            if (Test-Path $tempPath) {
                Remove-Item $tempPath -Recurse -Force
            }
        }
    }
    catch {
        Handle-Error -ErrorRecord $_ `
            -ComponentName "PowerShell Profile" `
            -Operation "Installation" `
            -Critical
        throw
    }
}