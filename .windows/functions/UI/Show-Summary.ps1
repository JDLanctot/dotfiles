function Show-Summary {
    param(
        [hashtable]$Results
    )
    
    $summary = @"
╔════════════════════════════════════════════════════════════════════════════════╗
║                           Installation Summary                                 ║
╠════════════════════════════════════════════════════════════════════════════════╣
║ Total Steps:    {0,4}                                                          ║
║ Successful:     {1,4}                                                          ║
║ Failed:         {2,4}                                                          ║
║ Skipped:        {3,4}                                                          ║
╚════════════════════════════════════════════════════════════════════════════════╝
"@ -f $Results.Total, $Results.Successful, $Results.Failed, $Results.Skipped

    Write-Host $summary -ForegroundColor $(if ($Results.Failed -eq 0) { "Green" } else { "Yellow" })
    
    if ($Results.FailedSteps.Count -gt 0) {
        Write-Host "`nFailed Steps:" -ForegroundColor Red
        foreach ($step in $Results.FailedSteps) {
            Write-Host "  • $step" -ForegroundColor Red
        }
    }
    
    Write-Host "`nLog File: $SCRIPT_LOG_PATH" -ForegroundColor Cyan
}