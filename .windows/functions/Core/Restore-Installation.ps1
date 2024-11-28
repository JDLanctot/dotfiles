function Restore-Installation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StepName
    )

    try {
        Write-Log "Attempting to restore installation state for step: $StepName" -Level "INFO"

        # First try to restore from backup
        $backupRestored = Restore-InstallationState -StepName $StepName
        if ($backupRestored) {
            Write-Log "Successfully restored from backup" -Level "SUCCESS"
            return $true
        }

        # If backup restoration fails, try recovery point
        Write-Log "Backup restoration failed, attempting recovery from checkpoint" -Level "WARN"
        $recoveryState = Resume-RecoveryPoint -LastSuccessfulStep $StepName
        if ($recoveryState) {
            Write-Log "Successfully restored from recovery point" -Level "SUCCESS"
            return $true
        }

        # If both fail, attempt to detect and fix partial installations
        Write-Log "Recovery failed, checking for partial installations" -Level "WARN"
        $partialInstalls = Get-PartialInstallations
        foreach ($install in $partialInstalls) {
            try {
                Remove-PartialInstallation $install
                Write-Log "Removed partial installation: $($install.Path)" -Level "INFO"
            }
            catch {
                Write-Log "Failed to remove partial installation: $_" -Level "ERROR"
            }
        }

        # If we get here, all recovery attempts failed
        throw "Unable to restore installation state"
    }
    catch {
        Write-Log "Installation restoration failed: $_" -Level "ERROR"
        return $false
    }
}