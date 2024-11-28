function Test-ComponentState {
    param(
        [string]$Component,
        [PSObject]$State
    )
    
    if (-not (Get-Variable -Name 'HELPERS_ROOT' -Scope Script -ErrorAction SilentlyContinue)) {
        throw "Module is not properly initialized. HELPERS_ROOT is not defined."
    }

    try {
        $verificationResult = Test-ComponentInstallation -Component $Component
        return $verificationResult.Success
    }
    catch {
        Write-Log "Failed to verify component state: $_" -Level "ERROR"
        return $false
    }
}