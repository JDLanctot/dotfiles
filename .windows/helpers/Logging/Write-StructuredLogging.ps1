function Write-StructuredLog {
    param(
        [string]$Message,
        [string]$Level = "INFO",
        [string]$Component,
        [hashtable]$Data
    )
    
    $logEntry = @{
        Timestamp   = Get-Date -Format "o"
        Level       = $Level
        Message     = $Message
        Component   = $Component
        Data        = $Data
        MachineName = $env:COMPUTERNAME
        Username    = $env:USERNAME
        ProcessId   = $PID
        SessionId   = $INSTALLATION_STATE.SessionId  # Add this to your initial state
    }
    
    # Create logs directory if it doesn't exist
    $logPath = Join-Path $env:TEMP "windows_setup_logs"
    if (-not (Test-Path $logPath)) {
        New-Item -ItemType Directory -Path $logPath | Out-Null
    }
    
    # Write to JSON log file
    $logFile = Join-Path $logPath "setup_$(Get-Date -Format 'yyyyMMdd').jsonl"
    $logEntry | ConvertTo-Json -Compress | Add-Content -Path $logFile

    # Also write to console using existing Write-Log function
    Write-Log -Message $Message -Level $Level
}