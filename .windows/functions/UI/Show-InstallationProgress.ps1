function Show-InstallationProgress {
    param(
        [string]$Phase,
        [int]$Current,
        [int]$Total,
        [hashtable]$ComponentStatus
    )
    
    try {
        # Prevent division by zero
        if ($Total -eq 0) {
            $percentComplete = 0
            $completed = 0
        }
        else {
            $percentComplete = [math]::Floor(($Current / $Total) * 100)
            $width = 50
            $completed = [math]::Floor(($width * $Current) / $Total)
        }
        
        $progressBar = "[" + ("█" * $completed) + ("░" * ($width - $completed)) + "]"
        
        $status = @"
╔════════════════════════════════════════════════════════════════╗
║ Installation Progress: $Phase
║ $progressBar $percentComplete%
║
║ Status:
$(foreach ($component in $ComponentStatus.Keys) {
    $status = $ComponentStatus[$component]
    "║ • ${component}: ${status}"
})
╚════════════════════════════════════════════════════════════════╝
"@
    
        Write-Host $status
    }
    catch {
        Write-Log "Failed to show progress: $_" -Level "ERROR"
        # Continue execution even if progress display fails
    }
}