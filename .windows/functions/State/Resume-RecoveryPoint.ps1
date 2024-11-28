function Resume-RecoveryPoint {
    [CmdletBinding()]
    param(
        [string]$LastSuccessfulStep,
        [Parameter(ParameterSetName = 'ByPoint')]
        [hashtable]$RecoveryPoint
    )
    
    try {
        $recoveryState = $null
        
        # If specific recovery point provided, use it
        if ($RecoveryPoint) {
            $recoveryState = $RecoveryPoint
        }
        # Otherwise find the latest recovery point for the step
        else {
            $recoveryPath = Join-Path $env:TEMP "WindowsSetup\recovery"
            $recoveryFiles = Get-ChildItem -Path $recoveryPath -Filter "recovery_${LastSuccessfulStep}_*.json" | 
            Sort-Object LastWriteTime -Descending
            
            if (-not $recoveryFiles) {
                throw "No recovery points found for step: $LastSuccessfulStep"
            }
            
            $recoveryState = Get-Content $recoveryFiles[0].FullName | ConvertFrom-Json -AsHashtable
        }
        
        # Validate recovery state
        if (-not ($recoveryState.InstallationState -and $recoveryState.InstalledComponents)) {
            throw "Invalid recovery state"
        }
        
        # Restore installation state
        $script:INSTALLATION_STATE = $recoveryState.InstallationState
        $script:INSTALLED_COMPONENTS = $recoveryState.InstalledComponents
        
        # Verify components
        $verificationResults = @()
        foreach ($component in $script:INSTALLED_COMPONENTS.Keys) {
            $verificationResults += Test-ComponentInstallation -Component $component
        }
        
        # Log verification results
        $failedVerifications = $verificationResults | Where-Object { -not $_.Success }
        if ($failedVerifications) {
            Write-Log "Some components failed verification:" -Level "WARN"
            foreach ($failure in $failedVerifications) {
                Write-Log "- $($failure.Component): $($failure.Error)" -Level "WARN"
            }
        }
        
        Write-Log "Successfully restored state from recovery point" -Level "SUCCESS"
        return $recoveryState.StepMetadata
    }
    catch {
        Write-Log "Failed to restore from recovery point: $_" -Level "ERROR"
        return $null
    }
}