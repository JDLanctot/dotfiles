function Show-InstallationPlan {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [array]$Steps,
        [Parameter(Mandatory = $true)]
        [string]$Type
    )
    
    $planOutput = @"
╔════════════════════════════════════════════════════════════════╗
║                     Installation Plan: $Type                    
╠════════════════════════════════════════════════════════════════╣
"@
    
    foreach ($step in $Steps) {
        $required = if ($step.Required) { "[Required]" } else { "[Optional]" }
        $planOutput += "`n║ • $($step.Name) $required"
    }
    
    $planOutput += @"
║
╚════════════════════════════════════════════════════════════════╝
"@
    
    Write-Host $planOutput
    
    if (-not $Silent) {
        $response = Read-Host "Continue with installation? (Y/N)"
        if ($response -ne "Y") {
            Write-Log "Installation cancelled by user" -Level "INFO"
            exit 0
        }
    }
}