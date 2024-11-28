function Test-ModulePaths {
    [CmdletBinding()]
    param()

    if (-not (Get-Variable -Name 'HELPERS_ROOT' -Scope Script -ErrorAction SilentlyContinue)) {
        throw "Module is not properly initialized. HELPERS_ROOT is not defined."
    }
    

    $requiredPaths = @(
        'MODULE_ROOT',
        'CONFIG_ROOT',
        'FUNCTIONS_ROOT',
        'HELPERS_ROOT',
        'CLASSES_ROOT'
    )

    foreach ($path in $requiredPaths) {
        $value = Get-Variable -Name $path -Scope Script -ErrorAction SilentlyContinue
        
        if (-not $value -or -not (Test-Path $value.Value)) {
            throw "Required path variable $path is not set or path does not exist"
        }
    }
    
    return $true
}