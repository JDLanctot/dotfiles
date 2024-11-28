function Remove-Installation {
    [CmdletBinding()]
    param(
        [switch]$KeepConfigs,
        [switch]$Force,
        [switch]$RemoveBackups,
        [switch]$RemoveLogs
    )

    try {
        if (-not $Force) {
            $response = Show-Checkpoint -Message "Remove Installation" -Detail "This will remove all installed components. Are you sure?" -Confirm
            if ($response -ne "Continue") {
                Write-Log "Uninstallation cancelled by user" -Level "INFO"
                return $false
            }
        }

        # Get installed components
        $components = Get-Content "$env:USERPROFILE\.dotfiles_installed" -ErrorAction SilentlyContinue
        if (-not $components) {
            Write-Log "No installation state found" -Level "WARN"
            return $true
        }

        $results = @{
            Removed = @()
            Failed  = @()
            Skipped = @()
        }

        # Remove each component
        foreach ($component in $components) {
            Write-Log "Removing $component..." -Level "INFO"

            try {
                # Get component uninstallation script if exists
                $uninstallScript = Get-UninstallScript -Component $component
                if ($uninstallScript) {
                    $success = & $uninstallScript
                    if (-not $success) {
                        throw "Uninstallation script failed"
                    }
                }

                # Restore original configurations if they exist and not keeping configs
                if (-not $KeepConfigs) {
                    $configPath = Get-ComponentConfigPath -Component $component
                    if ($configPath) {
                        $backup = Get-LatestBackup -Path $configPath
                        if ($backup) {
                            Restore-Configuration -BackupPath $backup -TargetPath $configPath -Type "file"
                        }
                    }
                }

                $results.Removed += $component
            }
            catch {
                Write-Log "Failed to remove $(component): $_" -Level "ERROR"
                $results.Failed += @{
                    Component = $component
                    Error     = $_.Exception.Message
                }
            }
        }

        # Cleanup
        if ($RemoveBackups) {
            Remove-OldBackups -RemoveAll
        }

        if ($RemoveLogs) {
            Remove-InstallationLogs
        }

        # Remove installation state file
        Remove-Item "$env:USERPROFILE\.dotfiles_installed" -Force -ErrorAction SilentlyContinue

        # Show results
        Write-Log "Uninstallation completed" -Level "SUCCESS"
        if ($results.Removed.Count -gt 0) {
            Write-Log "Successfully removed: $($results.Removed -join ', ')" -Level "SUCCESS"
        }
        if ($results.Failed.Count -gt 0) {
            Write-Log "Failed to remove: $($results.Failed.Component -join ', ')" -Level "ERROR"
        }

        return $true
    }
    catch {
        Write-Log "Uninstallation failed: $_" -Level "ERROR"
        return $false
    }
}