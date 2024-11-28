function Test-ModuleManifest {
    $manifestPath = Join-Path $PSScriptRoot "WindowsSetup.psd1"

    if (-not (Get-Variable -Name 'HELPERS_ROOT' -Scope Script -ErrorAction SilentlyContinue)) {
        throw "Module is not properly initialized. HELPERS_ROOT is not defined."
    }
    
    
    if (-not (Test-Path $manifestPath)) {
        throw "Module manifest not found at: $manifestPath"
    }
    
    try {
        $manifest = Test-ModuleManifest $manifestPath -ErrorAction Stop
        $requiredFunctions = @(
            'Start-Installation',
            'Install-BasicPrograms',
            'Install-CliTools'
        )
        
        foreach ($function in $requiredFunctions) {
            if ($function -notin $manifest.ExportedFunctions.Keys) {
                throw "Required function '$function' not exported in manifest"
            }
        }
        return $true
    }
    catch {
        throw "Invalid module manifest: $_"
    }
}