function Test-ConfigSchema {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$Config
    )

    if (-not (Get-Variable -Name 'HELPERS_ROOT' -Scope Script -ErrorAction SilentlyContinue)) {
        throw "Module is not properly initialized. HELPERS_ROOT is not defined."
    }
    
    try {
        $requiredSections = @(
            'Paths',
            'Programs',
            'CliTools',
            'InstallationProfiles',
            'MinimumRequirements'
        )
        
        # Validate required sections
        foreach ($section in $requiredSections) {
            if (-not $Config.ContainsKey($section)) {
                throw "Missing required config section: $section"
            }
        }
        
        # Validate paths
        if ($Config.Paths) {
            foreach ($path in $Config.Paths.Keys) {
                $pathConfig = $Config.Paths[$path]
                if (-not ($pathConfig.source -and $pathConfig.target -and $pathConfig.type)) {
                    throw "Invalid path configuration for: $path"
                }
            }
        }
        
        # Validate installation profiles
        if ($Config.InstallationProfiles) {
            foreach ($profile in $Config.InstallationProfiles.Keys) {
                $profileConfig = $Config.InstallationProfiles[$profile]
                if (-not $profileConfig.Steps) {
                    throw "Missing steps in installation profile: $profile"
                }
            }
        }
        
        return $true
    }
    catch {
        Write-Log "Config schema validation failed: $_" -Level "ERROR"
        return $false
    }
}