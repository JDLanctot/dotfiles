function Initialize-RecoveryPoint {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StepName,
        [Parameter(Mandatory = $true)]
        [hashtable]$State
    )
    
    try {
        # Create recovery points directory if it doesn't exist
        $recoveryPath = Join-Path $env:TEMP "WindowsSetup\recovery"
        if (-not (Test-Path $recoveryPath)) {
            New-Item -ItemType Directory -Path $recoveryPath -Force | Out-Null
            Write-Log "Created recovery points directory" -Level "DEBUG"
        }
        
        # Prepare recovery state
        $recoveryState = @{
            StepName            = $StepName
            Timestamp           = Get-Date
            SessionId           = $script:INSTALLATION_STATE.SessionId
            InstallationState   = $script:INSTALLATION_STATE
            InstalledComponents = $script:INSTALLED_COMPONENTS
            StepMetadata        = $State
            BackupPaths         = @()
        }
        
        # Add backup paths if they exist
        if ($script:INSTALLATION_STATE.Steps[$StepName]) {
            $recoveryState.BackupPaths = $script:INSTALLATION_STATE.Steps[$StepName].BackupPaths
        }
        
        # Create recovery point file
        $recoveryFile = Join-Path $recoveryPath "recovery_${StepName}_$(Get-Date -Format 'yyyyMMddHHmmss').json"
        $recoveryState | ConvertTo-Json -Depth 10 | Set-Content $recoveryFile
        
        Write-Log "Created recovery point for step: $StepName" -Level "DEBUG"
        return $true
    }
    catch {
        Write-Log "Failed to create recovery point: $_" -Level "ERROR"
        return $false
    }
}