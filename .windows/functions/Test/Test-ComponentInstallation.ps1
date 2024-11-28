function Test-ComponentInstallation {
    param(
        [string]$Component
    )

    if (-not (Get-Variable -Name 'HELPERS_ROOT' -Scope Script -ErrorAction SilentlyContinue)) {
        throw "Module is not properly initialized. HELPERS_ROOT is not defined."
    }    
    
    # Define component-specific verification tests
    $verificationTests = @{
        'git'      = {
            $gitVersion = git --version
            return @{ Success = $true; Version = $gitVersion }
        }
        'neovim'   = {
            if (-not (Test-Path "$env:LOCALAPPDATA\nvim\init.lua")) {
                return @{ Success = $false; Error = "Missing init.lua" }
            }
            $nvimVersion = nvim --version
            return @{ Success = $true; Version = $nvimVersion }
        }
        'starship' = {
            if (-not (Test-Path "$env:USERPROFILE\.starship\starship.toml")) {
                return @{ Success = $false; Error = "Missing starship.toml" }
            }
            return @{ Success = $true }
        }
    }
    
    try {
        $componentPath = Get-ComponentPath -Component $Component
        if ($componentPath) {
            $signatureValid = Test-ComponentSignature -ComponentPath $componentPath `
                -RequireSignature:($Component -in @('git', 'neovim', 'node'))
            if (-not $signatureValid) {
                return @{ 
                    Success = $false 
                    Error   = "Component signature verification failed"
                }
            }
        }
        
        if ($verificationTests.ContainsKey($Component)) {
            return & $verificationTests[$Component]
        }
        
        # Default verification just checks command existence
        $commandExists = Get-Command -Name $Component -ErrorAction SilentlyContinue
        return @{ Success = $null -ne $commandExists }
    }
    catch {
        return @{ Success = $false; Error = $_.Exception.Message }
    }
}
