function Test-CompleteInstallation {
    param([string]$Profile = "Minimal")

    if (-not (Get-Variable -Name 'HELPERS_ROOT' -Scope Script -ErrorAction SilentlyContinue)) {
        throw "Module is not properly initialized. HELPERS_ROOT is not defined."
    }
    
    
    $results = @{
        Successful = @()
        Failed     = @()
    }
    
    # Test all components
    foreach ($component in $script:INSTALLED_COMPONENTS.Keys) {
        $test = Test-ComponentInstallation -Component $component
        if ($test.Success) {
            $results.Successful += $component
        }
        else {
            $results.Failed += @{
                Component = $component
                Error     = $test.Error
            }
        }
    }
    
    return $results
}