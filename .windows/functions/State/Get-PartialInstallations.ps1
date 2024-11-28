function Get-PartialInstallations {
    [CmdletBinding()]
    param()
    
    try {
        $partialInstalls = @()
        
        # Get all registered components
        $components = Get-Content "$env:USERPROFILE\.dotfiles_installed" -ErrorAction SilentlyContinue
        
        foreach ($component in $components) {
            # Skip if component not in registry
            if (-not $script:INSTALLED_COMPONENTS.ContainsKey($component)) {
                continue
            }
            
            $componentData = $script:INSTALLED_COMPONENTS[$component]
            
            # Component path doesn't exist
            if ($componentData.Path -and -not (Test-Path $componentData.Path)) {
                $partialInstalls += @{
                    Component   = $component
                    Path        = $componentData.Path
                    Type        = "MissingPath"
                    InstalledOn = $componentData.InstalledOn
                }
                continue
            }
            
            # Component state file exists but component verification fails
            $stateFile = Join-Path $env:USERPROFILE ".${component}_state.json"
            if (Test-Path $stateFile) {
                $stateData = Get-Content $stateFile | ConvertFrom-Json
                if (-not (Test-ComponentState -Component $component -State $stateData)) {
                    $partialInstalls += @{
                        Component   = $component
                        Path        = $componentData.Path
                        Type        = "InvalidState"
                        InstalledOn = $componentData.InstalledOn
                    }
                    continue
                }
            }
            
            # Component-specific verification
            $verificationResult = Test-ComponentInstallation -Component $component
            if (-not $verificationResult.Success) {
                $partialInstalls += @{
                    Component   = $component
                    Path        = $componentData.Path
                    Type        = "VerificationFailed"
                    Error       = $verificationResult.Error
                    InstalledOn = $componentData.InstalledOn
                }
            }
        }
        
        # Check for common partial installation indicators
        $indicators = @(
            @{
                Path      = "$env:LOCALAPPDATA\nvim"
                Test      = { -not (Test-Path "$env:LOCALAPPDATA\nvim\init.lua") }
                Component = "neovim"
            },
            @{
                Path      = "$env:USERPROFILE\.config"
                Test      = { (Get-ChildItem).Count -eq 0 }
                Component = "dotfiles"
            },
            @{
                Path      = "$env:USERPROFILE\.starship"
                Test      = { -not (Test-Path "$env:USERPROFILE\.starship\starship.toml") }
                Component = "starship"
            }
        )
        
        foreach ($indicator in $indicators) {
            if (Test-Path $indicator.Path) {
                $isPartial = & $indicator.Test
                if ($isPartial) {
                    $partialInstalls += @{
                        Component   = $indicator.Component
                        Path        = $indicator.Path
                        Type        = "Partial"
                        InstalledOn = (Get-Item $indicator.Path).CreationTime
                    }
                }
            }
        }
        
        return $partialInstalls
    }
    catch {
        Write-Log "Failed to check for partial installations: $_" -Level "ERROR"
        return @()
    }
}