function Test-RequiredFunctions {
    $requiredFunctions = @(
        'Get-LatestRecoveryPoint',
        'Initialize-RecoveryPoint',
        'Initialize-Installation'
        # Add other critical functions here
    )

    $missingFunctions = @()
    foreach ($function in $requiredFunctions) {
        if (-not (Get-Command -Name $function -ErrorAction SilentlyContinue)) {
            $missingFunctions += $function
        }
    }

    if ($missingFunctions.Count -gt 0) {
        Write-Log "Missing required functions: $($missingFunctions -join ', ')" -Level "ERROR"
        return $false
    }
    return $true
}