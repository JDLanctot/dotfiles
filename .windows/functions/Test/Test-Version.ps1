function Test-Version {
    param (
        [string]$Current,
        [string]$Required
    )
    
    if (-not (Get-Variable -Name 'HELPERS_ROOT' -Scope Script -ErrorAction SilentlyContinue)) {
        throw "Module is not properly initialized. HELPERS_ROOT is not defined."
    }

    return ([System.Version]$Current -ge [System.Version]$Required)
}