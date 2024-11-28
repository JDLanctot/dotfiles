function Clear-OldRecoveryPoints {
    param([int]$KeepDays = 7)
    
    try {
        $recoveryPath = Join-Path $env:TEMP "WindowsSetup\recovery"
        if (-not (Test-Path $recoveryPath)) {
            return
        }
        
        $cutoffDate = (Get-Date).AddDays(-$KeepDays)
        Get-ChildItem -Path $recoveryPath -Filter "recovery_*.json" | 
        Where-Object { $_.LastWriteTime -lt $cutoffDate } | 
        Remove-Item -Force
    }
    catch {
        Write-Log "Failed to clean old recovery points: $_" -Level "WARN"
    }
}