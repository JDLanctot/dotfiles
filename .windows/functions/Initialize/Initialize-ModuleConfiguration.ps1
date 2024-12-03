function Initialize-ModuleConfiguration {
    Write-Log "Loading configuration..." -Level "INFO"
    
    try {
        # Validate configuration
        if (-not (Test-ConfigSchema -Config $script:Config)) {
            throw "Invalid configuration schema"
        }
        
        # Process paths
        $processedPaths = @{}
        foreach ($key in $script:Config.Paths.Keys) {
            $pathConfig = $script:Config.Paths[$key]
            
            if (-not ($pathConfig.source -and $pathConfig.target -and $pathConfig.type)) {
                Write-Log "Invalid path configuration for $key" -Level "ERROR"
                continue
            }

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
        Write-Log "Configuration processed successfully" -Level "SUCCESS"
        return $true
    }
    catch {
        Write-Log "Failed to process configuration: $_" -Level "ERROR"
        throw
    }
}