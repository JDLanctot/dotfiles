function Backup-Configuration {
    param(
        [string]$Path,
        [string]$Type = 'file'
    )
    
    $backupPath = Join-Path $env:TEMP "WindowsSetup\backups"
    $timestamp = Get-Date -Format "yyyyMMddHHmmss"
    $backupFile = Join-Path $backupPath "${Path}_${timestamp}.backup"
    
    try {
        if (-not (Test-Path $backupPath)) {
            New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
        }
        
        if ($Type -eq 'directory') {
            Copy-Item $Path $backupFile -Recurse -Force
        }
        else {
            Copy-Item $Path $backupFile -Force
        }
        
        return $backupFile
    }
    catch {
        Write-Log "Failed to create backup: $_" -Level "ERROR"
        return $null
    }
}