function Install-CliTools {
    [CmdletBinding()]
    param()
    
    if (Test-InstallationState "CLI Tools") {
        Write-ColorOutput "CLI tools already installed and configured" "Status"
        return $false
    }

    Write-ColorOutput "Installing CLI tools..." "Status"
    
    $failed = @()
    $installed = @()
    $skipped = @()

    foreach ($tool in $Config.CliTools) {
        try {
            # Use alias if specified, otherwise use name
            $commandToCheck = if ($tool.Alias) { $tool.Alias } else { $tool.Name }
            
            if (-not (Test-Command $commandToCheck)) {
                Write-ColorOutput "Installing $($tool.Name)..." "Status"
                
                Invoke-SafeCommand { 
                    choco install $tool.Name -y 
                } -ErrorMessage "Failed to install $($tool.Name)"
                
                RefreshPath
                
                if (Test-Command $commandToCheck) {
                    $installed += $tool.Name
                    Write-ColorOutput "$($tool.Name) installed successfully" "Success"
                }
                else {
                    throw "Installation verification failed for $($tool.Name) (command: $commandToCheck)"
                }
            }
            else {
                Write-ColorOutput "$($tool.Name) is already installed" "Status"
                $skipped += $tool.Name
            }

            # Configure if needed
            if ($tool.ConfigCheck -and $tool.ConfigText) {
                if (-not (Test-Path $PROFILE)) {
                    New-Item -Path $PROFILE -ItemType File -Force | Out-Null
                    Write-ColorOutput "Created new PowerShell profile" "Status"
                }

                if (-not (Select-String -Path $PROFILE -Pattern $tool.ConfigCheck -Quiet -ErrorAction SilentlyContinue)) {
                    Add-Content -Path $PROFILE -Value "`n$($tool.ConfigText)"
                    Write-ColorOutput "$($tool.Name) configuration added to profile" "Success"
                }
                else {
                    Write-ColorOutput "$($tool.Name) already configured in profile" "Status"
                }
            }
        }
        catch {
            $failed += $tool.Name
            Write-ColorOutput "Failed to setup $($tool.Name): $_" "Error"
            
            if ($tool.Required) {
                Handle-Error -ErrorRecord $_ `
                    -ComponentName "CLI Tools" `
                    -Operation "Installation" `
                    -Critical
                throw
            }
        }
    }

    # Summary
    if ($installed.Count -gt 0) {
        Write-ColorOutput "Installed: $($installed -join ', ')" "Success"
    }
    if ($skipped.Count -gt 0) {
        Write-ColorOutput "Already installed: $($skipped -join ', ')" "Status"
    }
    if ($failed.Count -gt 0) {
        Write-ColorOutput "Failed to install: $($failed -join ', ')" "Warn"
    }

    # Reload profile
    try {
        Write-ColorOutput "Reloading PowerShell profile..." "Status"
        . $PROFILE
        Write-ColorOutput "PowerShell profile reloaded" "Success"
    }
    catch {
        Write-ColorOutput "Failed to reload PowerShell profile: $_" "Warn"
        Write-ColorOutput "Please restart your PowerShell session to apply changes" "Warn"
    }

    Save-InstallationState "CLI Tools"
    Write-ColorOutput "CLI tools configuration completed" "Success"
    if ($installed.Count -gt 0) {
        Save-InstallationState "CLI Tools"
        Write-ColorOutput "CLI tools configuration completed" "Success"
        return $true
    }
    else {
        Write-ColorOutput "No new CLI tools needed to be installed" "Status"
        return $false  # Return false when nothing was installed
    }
}