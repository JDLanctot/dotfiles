function Test-ModuleDependencies {
    param(
        [hashtable]$RequiredModules = @{
            'Microsoft.PowerShell.Security'   = '7.0.0'
            'Microsoft.PowerShell.Management' = '7.0.0'
        }
    )

    if (-not (Get-Variable -Name 'HELPERS_ROOT' -Scope Script -ErrorAction SilentlyContinue)) {
        throw "Module is not properly initialized. HELPERS_ROOT is not defined."
    }
    
    
    foreach ($module in $RequiredModules.Keys) {
        $version = $RequiredModules[$module]
        if (-not (Get-Module -ListAvailable $module | Where-Object { $_.Version -ge $version })) {
            Write-Log "Required module $module (>= $version) not found" -Level "ERROR"
            throw "Required module $module (>= $version) not found"
        }
    }
}
