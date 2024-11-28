function Get-LatestRecoveryPoint {
    [CmdletBinding()]
    param()
    
    try {
        $recoveryPath = Join-Path $env:TEMP "WindowsSetup\recovery"
        if (-not (Test-Path $recoveryPath)) {
            Write-Log "No recovery points found - directory does not exist." -Level "DEBUG"
            return $null
        }
        
        # Get most recent recovery point
        $latestRecovery = Get-ChildItem -Path $recoveryPath -Filter "recovery_*.json" |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1
        
        if ($latestRecovery) {
            Write-Log "Found recovery point: $($latestRecovery.Name)" -Level "INFO"
            $recoveryData = Get-Content $latestRecovery.FullName | ConvertFrom-Json -AsHashtable
            return @{
                StepName  = $recoveryData.StepName
                Timestamp = $recoveryData.Timestamp
                State     = $recoveryData.StepMetadata
                Path      = $latestRecovery.FullName
            }
        }
        
        Write-Log "No recovery points found" -Level "DEBUG"
        return $null
    }
    catch {
        Write-Log "Failed to get latest recovery point: $_" -Level "ERROR"
        return $null
    }
}