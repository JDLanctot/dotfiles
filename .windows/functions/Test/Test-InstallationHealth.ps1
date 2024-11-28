function Test-InstallationHealth {
    param(
        [string]$Component
    )

    if (-not (Get-Variable -Name 'HELPERS_ROOT' -Scope Script -ErrorAction SilentlyContinue)) {
        throw "Module is not properly initialized. HELPERS_ROOT is not defined."
    }
    
    $verificationTests = @{
        'git'    = @{
            Command    = { git --version }
            ConfigTest = { git config --get user.name }
            Paths      = @("$env:ProgramFiles\Git", "$env:ProgramFiles\Git\cmd\git.exe")
        }
        'neovim' = @{
            Command    = { nvim --version }
            ConfigTest = { Test-Path (Join-Path $env:LOCALAPPDATA "nvim\init.lua") }
            Paths      = @("$env:LOCALAPPDATA\nvim", "$env:ProgramFiles\Neovim\bin\nvim.exe")
        }
        # Add more component tests as needed
    }
    
    if (-not $verificationTests.ContainsKey($Component)) {
        Write-Log "No verification tests defined for $Component" -Level "WARN"
        return $null
    }
    
    $tests = $verificationTests[$Component]
    $results = @{
        Component       = $Component
        Status          = "Unknown"
        Tests           = @{}
        Recommendations = @()
    }
    
    try {
        # Test command execution
        if ($tests.Command) {
            $cmdResult = Invoke-Command -ScriptBlock $tests.Command -ErrorAction SilentlyContinue
            $results.Tests["Command"] = $null -ne $cmdResult
        }
        
        # Test configuration
        if ($tests.ConfigTest) {
            $configResult = Invoke-Command -ScriptBlock $tests.ConfigTest -ErrorAction SilentlyContinue
            $results.Tests["Config"] = $null -ne $configResult
        }
        
        # Test paths
        if ($tests.Paths) {
            $results.Tests["Paths"] = @{}
            foreach ($path in $tests.Paths) {
                $results.Tests["Paths"][$path] = Test-Path $path
            }
        }
        
        # Determine overall status
        $failedTests = $results.Tests.Values | Where-Object { -not $_ }
        if ($failedTests) {
            $results.Status = "Degraded"
            $results.Recommendations += "Some component tests failed. Consider reinstalling $Component"
        }
        else {
            $results.Status = "Healthy"
        }
    }
    catch {
        $results.Status = "Failed"
        $results.Error = $_.ToString()
        $results.Recommendations += "Component verification failed. Check logs for details"
    }
    
    return $results
}