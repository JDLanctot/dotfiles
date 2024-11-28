function Initialize-ModuleConfiguration {
    Write-Log "Loading configuration..." -Level "INFO"
    
    # Validate config file exists
    $configPath = Join-Path $script:CONFIG_ROOT "config.psd1"
    if (-not (Test-Path $configPath)) {
        throw "Configuration file not found at: $configPath"
    }

    try {
        # Load configuration
        $loadedConfig = Import-PowerShellDataFile $configPath
        
        # Validate configuration
        if (-not (Test-ConfigSchema -Config $loadedConfig)) {
            throw "Invalid configuration schema"
        }
        
        # Assign to script scope
        $script:Config = $loadedConfig
        Write-Log "Configuration loaded successfully from: $configPath" -Level "SUCCESS"
        
        # Process and validate paths
        $processedPaths = @{}
        foreach ($key in $script:Config.Paths.Keys) {
            $pathConfig = $script:Config.Paths[$key]
            
            # Validate required path properties
            if (-not ($pathConfig.source -and $pathConfig.target -and $pathConfig.type)) {
                Write-Log "Invalid path configuration for $key" -Level "ERROR"
                continue
            }

            # Construct the target path based on the type
            $targetPath = switch ($key) {
                'nvim' { Join-Path $env:LOCALAPPDATA $pathConfig.target }
                'bat' { Join-Path $env:APPDATA $pathConfig.target }
                'powershell' { $PROFILE }
                default { Join-Path $env:USERPROFILE $pathConfig.target }
            }

            $processedPaths[$key] = @{
                'source' = $pathConfig.source
                'target' = $targetPath
                'type'   = $pathConfig.type
            }
        }

        $script:CONFIG_PATHS = $processedPaths
        return $true
    }
    catch {
        Write-Log "Failed to load configuration: $_" -Level "ERROR"
        throw
    }
}