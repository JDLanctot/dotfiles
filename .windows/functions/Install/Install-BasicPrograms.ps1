function Install-BasicPrograms {
    [CmdletBinding()]
    param()

    $didInstallSomething = $false

    try {
        Write-ColorOutput "Checking basic programs..." "Status"

        # Check each program first
        $missingPrograms = @()
        $existingPrograms = @()

        foreach ($program in $Config.Programs) {
            if (-not (Get-Command -Name $program.Alias -ErrorAction SilentlyContinue)) {
                $missingPrograms += $program
                Write-ColorOutput "$($program.Name) needs to be installed" "Status"
            }
            else {
                $existingPrograms += $program.Name
            }
        }

        if ($missingPrograms.Count -eq 0) {
            Write-ColorOutput "All basic programs are already installed" "Status"
            Save-InstallationState "basic_programs"
            return $false  # Explicitly return false when skipping
        }

        Write-ColorOutput "Installing missing basic programs..." "Status"
        foreach ($program in $missingPrograms) {
            try {
                Write-ColorOutput "Installing $($program.Name)..." "Status"
                
                $result = Invoke-SafeCommand { 
                    choco install $program.Name -y 
                } -ErrorMessage "Failed to install $($program.Name)"

                if (-not $result) {
                    throw "Installation failed for $($program.Name)"
                }

                # Verify installation
                RefreshPath
                if (-not (Get-Command -Name $program.Alias -ErrorAction SilentlyContinue)) {
                    throw "Verification failed for $($program.Name)"
                }

                Write-ColorOutput "$($program.Name) installed successfully" "Success"
                $didInstallSomething = $true
            }
            catch {
                if ($program.Required) {
                    throw
                }
                Write-ColorOutput "Failed to install $($program.Name): $_" "Error"
            }
        }

        if ($existingPrograms.Count -gt 0) {
            Write-ColorOutput "Already installed: $($existingPrograms -join ', ')" "Status"
        }

        if ($didInstallSomething) {
            Save-InstallationState "basic_programs"
            Write-ColorOutput "Basic programs installation completed" "Success"
            return $true  # Explicitly return true when we installed something
        }
        else {
            Write-ColorOutput "No new programs needed to be installed" "Status"
            return $false  # Explicitly return false when nothing was installed
        }
    }
    catch {
        # Restore backup if it exists
        if (Test-Path "$configPath.backup") {
            Move-Item "$configPath.backup" $configPath -Force
        }
        
        Handle-Error -ErrorRecord $_ `
            -ComponentName "BasicPrograms" `
            -Operation "Installation" `
            -Critical
        throw
    }
}
