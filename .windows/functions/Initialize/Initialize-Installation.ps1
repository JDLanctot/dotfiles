function Initialize-Installation {
    [CmdletBinding()]
    param(
        [ValidateSet('Minimal', 'Standard', 'Full')]
        [string]$InstallationType,
        [switch]$Force,
        [hashtable]$State = @{}
    )
    
    try {
        # Debug script scope variables
        Write-Log "Current Config state: $($null -ne $script:Config)" -Level "DEBUG"
        Write-Log "Current Installation State: $($null -ne $script:INSTALLATION_STATE)" -Level "DEBUG"
        
        # Initialize or get installation state
        if (-not $script:INSTALLATION_STATE) {
            $script:INSTALLATION_STATE = [InstallationState]::new()
            Write-Log "Created new installation state" -Level "DEBUG"
        }
        
        # Set session ID if not present
        if (-not $script:INSTALLATION_STATE.SessionId) {
            $script:INSTALLATION_STATE.SessionId = [guid]::NewGuid().ToString()
            Write-Log "Generated new session ID: $($script:INSTALLATION_STATE.SessionId)" -Level "DEBUG"
        }
        
        # Validate system requirements
        if (-not (Test-SystemRequirements)) {
            throw "System requirements not met"
        }
        
        # Initialize logging
        $logPath = Join-Path $env:TEMP "WindowsSetup\logs"
        if (-not (Test-Path $logPath)) {
            New-Item -ItemType Directory -Path $logPath -Force | Out-Null
        }
        
        # Check for existing recovery points if not forced
        if (-not $Force) {
            $recoveryPoint = Get-LatestRecoveryPoint
            if ($recoveryPoint) {
                Write-Log "Found existing recovery point from: $($recoveryPoint.Timestamp)" -Level "WARN"
                return @{
                    RecoveryAvailable = $true
                    RecoveryPoint     = $recoveryPoint
                }
            }
        }
        
        # Load configuration
        Write-Log "Loading configuration..." -Level "DEBUG"
        Initialize-Configuration
        
        # Verify configuration was loaded
        if (-not $script:Config) {
            throw "Configuration failed to load properly"
        }
        Write-Log "Configuration loaded successfully" -Level "DEBUG"
        Write-Log "Available installation profiles: $($script:Config.InstallationProfiles.Keys -join ', ')" -Level "DEBUG"
        
        # Initialize cache
        Write-Log "Initializing cache..." -Level "DEBUG"
        Initialize-Cache
        
        Write-Log "Installation initialization completed successfully" -Level "DEBUG"
        
        # Store config locally to ensure it's available
        $script:CURRENT_CONFIG = $script:Config
        
        # Return initialization state
        return @{
            RecoveryAvailable = $false
            InstallationType  = $InstallationType
            SessionId         = $script:INSTALLATION_STATE.SessionId
            StartTime         = Get-Date
            Config            = $script:Config  # Include config in return value
        }
    }
    catch {
        Write-Log "Installation initialization failed: $_" -Level "ERROR"
        throw
    }
}