function Get-VerificationScript {
    param([string]$StepName)
    
    $verificationPath = Join-Path $script:FUNCTIONS_ROOT "Verify\Verify-$StepName.ps1"
    if (Test-Path $verificationPath) {
        return (Get-Content $verificationPath -Raw)
    }
    return $null
}