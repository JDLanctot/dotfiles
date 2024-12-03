function Write-Log {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,
        [ValidateSet("ERROR", "WARN", "INFO", "SUCCESS", "DEBUG", "VERBOSE")]
        [string]$Level = "INFO",
        [switch]$NoConsole
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "${timestamp} [${Level}] ${Message}"

    # Always write to log file
    Add-Content -Path $SCRIPT_LOG_PATH -Value $logMessage

    # Return early if in silent mode and not an error
    if ($script:Silent -and $Level -notin @("ERROR", "WARN")) {
        return
    }


    # Only write to console if not suppressed and meets verbosity threshold
    if (-not $NoConsole) {
        # Skip DEBUG and VERBOSE messages in console unless in debug mode
        if ($Level -eq "DEBUG" -or $Level -eq "VERBOSE") {
            if (-not $DebugPreference -eq 'Continue') {
                return
            }
        }

        # Only show important INFO messages (you can customize this list)
        if ($Level -eq "INFO") {
            $importantPatterns = @(
                "Installing*",
                "Configuring*",
                "*installation completed*",
                "*already installed*"
            )
            
            $isImportant = $false
            foreach ($pattern in $importantPatterns) {
                if ($Message -like $pattern) {
                    $isImportant = $true
                    break
                }
            }
            
            if (-not $isImportant) {
                return
            }
        }

        $color = switch ($Level) {
            "ERROR" { "Red" }
            "WARN" { "Yellow" }
            "SUCCESS" { "Green" }
            default { "White" }
        }
        Write-Host $logMessage -ForegroundColor $color
    }
}