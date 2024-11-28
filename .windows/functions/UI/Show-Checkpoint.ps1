function Show-Checkpoint {
    param(
        [string]$Message,
        [string]$Detail = "",
        [switch]$Confirm,
        [switch]$Warning
    )
    
    Write-Host "`n┌─────────────────────────────────────────────" -ForegroundColor $(if ($Warning) { "Yellow" } else { "Cyan" })
    Write-Host "│ $Message" -ForegroundColor $(if ($Warning) { "Yellow" } else { "Cyan" })
    if ($Detail) {
        Write-Host "│" -ForegroundColor $(if ($Warning) { "Yellow" } else { "Cyan" })
        Write-Host "│ $Detail" -ForegroundColor White
    }
    Write-Host "└─────────────────────────────────────────────`n" -ForegroundColor $(if ($Warning) { "Yellow" } else { "Cyan" })
    
    if ($Confirm) {
        do {
            Write-Host "Continue? [Y]es, [N]o, or [S]kip this step" -ForegroundColor Yellow -NoNewline
            $response = Read-Host " "
            switch ($response.ToLower()) {
                "y" { return "Continue" }
                "n" { 
                    Write-Log "Installation cancelled by user at: $Message" -Level "INFO"
                    exit 0 
                }
                "s" { return "Skip" }
            }
        } while ($true)
    }
}