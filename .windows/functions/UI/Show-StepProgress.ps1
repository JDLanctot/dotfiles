function Show-StepProgress {
    param(
        [string]$StepName,
        [int]$CurrentStep,
        [int]$TotalSteps,
        [string]$Status
    )
    
    $width = 50
    $percentComplete = [math]::Floor(($CurrentStep / $TotalSteps) * $width)
    
    $progress = "[" + ("=" * $percentComplete) + ("." * ($width - $percentComplete)) + "]"
    $percentage = [math]::Floor(($CurrentStep / $TotalSteps) * 100)
    
    Write-Host "`n$StepName" -ForegroundColor Cyan
    Write-Host "$progress ($percentage%)" -ForegroundColor Yellow
    Write-Host "$Status`n"
}