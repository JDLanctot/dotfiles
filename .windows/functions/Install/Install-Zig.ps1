function Install-Zig {
    [CmdletBinding()]
    param()

    $didInstallSomething = $false

    try {
        Write-ColorOutput "Checking Zig installation..." "Status"

        if (Test-InstallationState "zig") {
            Write-ColorOutput "Zig already installed" "Status"
            return $false
        }

        Write-ColorOutput "Installing Zig..." "Status"

        # Install Zig if not present
        if (-not (Get-Command -Name zig -ErrorAction SilentlyContinue)) {
            Invoke-SafeCommand {
                choco install zig -y
            } -ErrorMessage "Failed to install Zig"
            
            RefreshPath
            $didInstallSomething = $true

            if (-not (Get-Command -Name zig -ErrorAction SilentlyContinue)) {
                throw "Zig installation verification failed"
            }
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
            $didInstallSomething = $true
        }

        if ($didInstallSomething) {
            $zigVersion = (zig version)
            Write-ColorOutput "Zig $zigVersion installed" "Success"
            Save-InstallationState "zig"
        }
        else {
            Write-ColorOutput "Zig was already properly configured" "Status"
        }

        return $didInstallSomething
    }
    catch {
        # Restore backup if it exists
        if (Test-Path "$configPath.backup") {
            Move-Item "$configPath.backup" $configPath -Force
        }
          
        Handle-Error -ErrorRecord $_ `
            -ComponentName "Zig" `
            -Operation "Installation" `
            -Critical
        throw
    }
}