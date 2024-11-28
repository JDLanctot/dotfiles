function Install-CliTools {
    [CmdletBinding()]
    param()
    
    if (Test-InstallationState "cli_tools") {
        Write-ColorOutput "CLI tools already installed and configured" "Status"
        return $false  # Changed to false to indicate skip
    }

    Write-ColorOutput "Installing CLI tools..." "Status"
    
    $failed = @()
    $installed = @()
    $skipped = @()
    $didInstallSomething = $false

    foreach ($tool in $Config.CliTools) {
        try {
            if (-not (Test-Command $tool.Name)) {
                Write-ColorOutput "Installing $($tool.Name)..." "Status"
                
                Invoke-SafeCommand { 
                    choco install $tool.Name -y 
                } -ErrorMessage "Failed to install $($tool.Name)"
                
                RefreshPath
                
                if (Test-Command $tool.Name) {
                    $installed += $tool.Name
                    $didInstallSomething = $true
                    Write-ColorOutput "$($tool.Name) installed successfully" "Success"
                }
                else {
                    throw "Installation verification failed"
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
                    $didInstallSomething = $true
                }

                if (-not (Select-String -Path $PROFILE -Pattern $tool.ConfigCheck -Quiet -ErrorAction SilentlyContinue)) {
                    Add-Content -Path $PROFILE -Value "`n$($tool.ConfigText)"
                    Write-ColorOutput "$($tool.Name) configuration added to profile" "Success"
                    $didInstallSomething = $true
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
                catch {
                    # Restore backup if it exists
                    if (Test-Path "$configPath.backup") {
                        Move-Item "$configPath.backup" $configPath -Force
                    }
                    
                    Handle-Error -ErrorRecord $_ `
                        -ComponentName "CLI Tools" `
                        -Operation "Installation" `
                        -Critical
                    throw
                }
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

    Save-InstallationState "cli_tools"
    Write-ColorOutput "CLI tools configuration completed" "Success"
    return $didInstallSomething  # Return true only if we installed something new
}