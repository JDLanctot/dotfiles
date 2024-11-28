function Initialize-Configuration {
    [CmdletBinding()]
    param()
    
    Write-Log "Loading configuration..." -Level "INFO"
    
    try {
        $configPath = Join-Path $script:CONFIG_ROOT "config.psd1"
        
        # Import configuration using Import-PowerShellDataFile with specific parameters
        $loadedConfig = Import-PowerShellDataFile -Path $configPath -ErrorAction Stop
        
        # Convert function strings to ScriptBlocks in installation profiles
        foreach ($profileName in $loadedConfig.InstallationProfiles.Keys) {
            $profile = $loadedConfig.InstallationProfiles[$profileName]
            foreach ($step in $profile.Steps) {
                if ($step.Function -is [string]) {
                    $functionName = $step.Function
                    $step.Function = [ScriptBlock]::Create($functionName)
                }
            }
        }
        
        $script:Config = $loadedConfig
        Write-Log "Configuration loaded successfully" -Level "SUCCESS"
        
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

        Write-Log "Configuration processed successfully" -Level "SUCCESS"
        return $true
    }
    catch {
        Write-Log "Failed to load configuration: $_" -Level "ERROR"
        throw
    }
}