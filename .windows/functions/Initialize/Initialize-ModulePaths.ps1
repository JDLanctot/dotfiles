function Initialize-ModulePaths {
    try {
        # Get module root
        $script:MODULE_ROOT = $PSScriptRoot
        if (-not $MODULE_ROOT) {
            $script:MODULE_ROOT = Split-Path -Parent $MyInvocation.MyCommand.Path
            if (-not $script:MODULE_ROOT) {
                throw "Unable to determine module root path"
            }
        }
        
        # Get parent directory where classes folder exists
        $parentPath = Split-Path -Parent $script:MODULE_ROOT
        
        # Define and validate required module paths
        $paths = @{
            Config    = Join-Path $parentPath "config"
            Functions = Join-Path $parentPath "functions"
            Helpers   = Join-Path $parentPath "helpers"
            Classes   = Join-Path $parentPath "classes"
        }
        
        foreach ($key in $paths.Keys) {
            $path = $paths[$key]
            Write-Log "Checking path: $path" -Level "DEBUG"
            if (-not (Test-Path $path)) {
                throw "Required module path not found: $path"
            }
            Set-Variable -Name "${key}_ROOT" -Value $path -Scope Script
            Write-Log "Set $key`_ROOT to: $path" -Level "DEBUG"
        }

        # Create runtime directories
        $runtimePaths = @{
            Logs     = Join-Path $env:TEMP "WindowsSetup\logs"
            Cache    = Join-Path $env:TEMP "WindowsSetup\cache"
            Recovery = Join-Path $env:TEMP "WindowsSetup\recovery"
        }

        foreach ($key in $runtimePaths.Keys) {
            $path = $runtimePaths[$key]
            if (-not (Test-Path $path)) {
                New-Item -ItemType Directory -Path $path -Force | Out-Null
            }
            Set-Variable -Name "${key}_ROOT" -Value $path -Scope Script
            Write-Log "Created runtime directory: $path" -Level "DEBUG"
        }
        
        return $true
    }
    catch {
        Write-Log "Failed to initialize module paths: $_" -Level "ERROR"
        throw
    }
}