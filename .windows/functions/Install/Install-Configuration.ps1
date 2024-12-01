function Install-Configuration {
    param(
        [string]$Name,
        [string]$TempPath
    )

    if (-not $CONFIG_PATHS.ContainsKey($Name)) {
        Write-ColorOutput "Unknown configuration: ${Name}" "Error"
        return $false
    }

    $config = $CONFIG_PATHS[$Name]

    # Special handling for Alacritty with color scheme
    if ($Name -eq 'alacritty') {
        $sourcePath = Join-Path $TempPath $config.source
        $targetPath = Join-Path $env:USERPROFILE $config.target

        # Create target directory if it doesn't exist
        if (-not (Test-Path $targetPath)) {
            New-Item -ItemType Directory -Path $targetPath -Force | Out-Null
        }

        try {
            # Copy main config file
            $mainConfig = Join-Path $sourcePath "alacritty.toml"
            Copy-Item $mainConfig (Join-Path $targetPath "alacritty.toml") -Force

            # Copy color scheme if specified
            if ($config.colorscheme) {
                $colorConfig = Join-Path $sourcePath "$($config.colorscheme).toml"
                Copy-Item $colorConfig (Join-Path $targetPath "$($config.colorscheme).toml") -Force
            }

            Write-ColorOutput "${Name} configuration installed" "Success"
            return $true
        }
        catch {
            Write-ColorOutput "Failed to install ${Name} configuration: ${_}" "Error"
            return $false
        }
    }
    # Standard configuration handling for other components
    else {
        $sourcePath = Join-Path $TempPath $config.source
        $targetPath = Join-Path $env:USERPROFILE $config.target

        # Create target directory if it doesn't exist
        $targetDir = Split-Path $targetPath -Parent
        if (-not (Test-Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        }

        try {
            if (Test-Path $sourcePath) {
                if ($config.type -eq 'directory') {
                    if (Test-Path $targetPath) {
                        Remove-Item $targetPath -Recurse -Force
                    }
                    Copy-Item $sourcePath $targetPath -Recurse -Force
                }
                else {
                    Copy-Item $sourcePath $targetPath -Force
                }
                Write-ColorOutput "${Name} configuration installed" "Success"
                return $true
            }
            else {
                Write-ColorOutput "${Name} configuration not found in dotfiles" "Error"
                return $false
            }
        }
        catch {
            Write-ColorOutput "Failed to install ${Name} configuration: ${_}" "Error"
            return $false
        }
    }
}