# Initialize empty module state
$script:Config = $null
$script:CONFIG_PATHS = $null
$script:INSTALLED_COMPONENTS = @{}

# Get module root path
$script:MODULE_ROOT = $PSScriptRoot
if (-not $MODULE_ROOT) {
    $MODULE_ROOT = Split-Path -Parent $MyInvocation.MyCommand.Path
    if (-not $MODULE_ROOT) {
        throw "Unable to determine module root path"
    }
}

# Initialize essential paths
$script:CONFIG_ROOT = Join-Path $MODULE_ROOT "config"
$script:FUNCTIONS_ROOT = Join-Path $MODULE_ROOT "functions"
$script:HELPERS_ROOT = Join-Path $MODULE_ROOT "helpers"
$script:CLASSES_ROOT = Join-Path $MODULE_ROOT "classes"

# Initialize logging path
$logDirectory = Join-Path $env:TEMP "WindowsSetup\logs"
if (-not (Test-Path $logDirectory)) {
    New-Item -ItemType Directory -Path $logDirectory -Force | Out-Null
}
$script:SCRIPT_LOG_PATH = Join-Path $logDirectory "setup_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

# Export paths for module-wide access
$ExecutionContext.SessionState.PSVariable.Set("WindowsSetup_ModulePaths", @{
        ModuleRoot    = $script:MODULE_ROOT
        ConfigRoot    = $script:CONFIG_ROOT
        FunctionsRoot = $script:FUNCTIONS_ROOT
        HelpersRoot   = $script:HELPERS_ROOT
        ClassesRoot   = $script:CLASSES_ROOT
        LogPath       = $script:SCRIPT_LOG_PATH
    })

# Validate all paths exist
$paths = @{
    'Module Root'    = $script:MODULE_ROOT
    'Config Root'    = $script:CONFIG_ROOT
    'Functions Root' = $script:FUNCTIONS_ROOT
    'Helpers Root'   = $script:HELPERS_ROOT
    'Classes Root'   = $script:CLASSES_ROOT
}

foreach ($pathName in $paths.Keys) {
    if (-not (Test-Path $paths[$pathName])) {
        throw "Required path '$pathName' not found: $($paths[$pathName])"
    }
}

# Load classes first (order matters!)
$classFiles = @(
    "WindowsSetupConfig.ps1",
    "InstallationState.ps1",
    "InstallationStep.ps1",
    "InstallationProgress.ps1",
    "InstallationTransaction.ps1"
)

foreach ($classFile in $classFiles) {
    $classPath = Join-Path $CLASSES_ROOT $classFile
    if (Test-Path $classPath) {
        . $classPath
    }
    else {
        throw "Required class file not found: $classPath"
    }
}

# Load ALL helper functions first since Initialize functions depend on them
$helperFolders = @(
    'Directory', # Contains Test-PathPermissions
    'Logging',
    'Transaction',
    'Utils'
)

foreach ($folder in $helperFolders) {
    $folderPath = Join-Path $HELPERS_ROOT $folder
    if (Test-Path $folderPath) {
        Get-ChildItem -Path $folderPath -Filter "*.ps1" | 
        ForEach-Object {
            . $_.FullName
        }
    }
}

# Function loading section - ordered by dependencies
$functionFolders = @(
    'State', # Load first as other functions may depend on state management
    'Test', # Load early as testing functions are used during initialization
    'Cache', # Load before Initialize as it's used in initialization
    'Core', # Core functions
    'Security', # Security functions
    'Network', # Network functions
    'Initialize', # Initialize functions that may depend on all above
    'Install', # Installation functions
    'UI'        # UI functions loaded last as they depend on other functions
)

foreach ($folder in $functionFolders) {
    $folderPath = Join-Path $FUNCTIONS_ROOT $folder
    if (Test-Path $folderPath) {
        Get-ChildItem -Path $folderPath -Filter "*.ps1" | 
        ForEach-Object {
            . $_.FullName
        }
    }
}

$configFiles = @(
    "config.psd1"
)

foreach ($configFile in $configFiles) {
    $configPath = Join-Path $CONFIG_ROOT $configFile
    if (Test-Path $configPath) {
        $script:Config = Import-PowerShellDataFile $configPath
    }
    else {
        throw "Required configuration file not found: $configPath"
    }
}

# Initialize installation state
$script:InstallationState = $null
$script:Progress = $null

# Main initialization
try {
    $global:LASTEXITCODE = 0
    Write-Log "Starting module initialization..." -Level "INFO"
    Test-ModulePaths
    Initialize-ModuleComponents
    Initialize-ModuleConfiguration
    
    Write-Log "Module initialization completed successfully" -Level "SUCCESS"
}
catch {
    Write-Log "Module initialization failed: $_" -Level "ERROR"
    throw
}

function Start-Installation {
    [CmdletBinding()]
    param(
        [ValidateSet('Minimal', 'Standard', 'Full')]
        [string]$InstallationType = 'Standard',
        [switch]$Force,
        [switch]$NoBackup,
        [switch]$Silent
    )
    
    try {
        # Initialize installation state
        $initResult = Initialize-Installation -InstallationType $InstallationType -Force:$Force
        
        # Use the config from the initialization result
        $configToUse = if ($script:Config) { $script:Config } else { $initResult.Config }
        
        if (-not $configToUse) {
            throw "No configuration available"
        }
        
        # Get installation steps from config
        $steps = $configToUse.InstallationProfiles[$InstallationType].Steps
        Write-Log "Found $($steps.Count) steps for profile $InstallationType" -Level "INFO"
        
        # Initialize results tracking
        $results = @{
            Total      = $steps.Count
            Successful = [System.Collections.ArrayList]::new()
            Failed     = [System.Collections.ArrayList]::new()
            Skipped    = [System.Collections.ArrayList]::new()
        }

        # Track progress
        $currentStep = 0
        $totalSteps = $steps.Count
        $status = @{}

        foreach ($step in $steps) {
            $currentStep++
            $percentComplete = [math]::Floor(($currentStep / $totalSteps) * 100)        
            $progressBar = "["
            $progressBar += "█" * [math]::Floor($percentComplete / 2)
            $progressBar += "░" * (50 - [math]::Floor($percentComplete / 2))
            $progressBar += "]"

            Write-Host "`n╔════════════════════════════════════════════════════════════════╗"
            Write-Host "║ Installation Progress: $($step.Name)"
            Write-Host "║ $progressBar $percentComplete%"
            Write-Host "║"
            Write-Host "║ Status:"
            foreach ($item in $status.GetEnumerator()) {
                Write-Host "║ • $($item.Key): $($item.Value)"
            }
            Write-Host "╚════════════════════════════════════════════════════════════════╝"

            try {
                # Check if already installed
                $isInstalled = Test-InstallationState $step.Name
                if ($isInstalled) {
                    Write-Log "$($step.Name) is already installed" -Level "INFO"
                    [void]$results.Skipped.Add($step.Name)
                    $status[$step.Name] = "Skipped"
                    continue
                }
        
                # Get the function to execute
                $function = $step.Function
                if ($function -is [ScriptBlock]) {
                    Write-Log "Executing script block for $($step.Name)" -Level "DEBUG"
                    $result = & $function
                }
                else {
                    # Try to get function by name
                    $functionName = $function.ToString().Trim('{}') # Remove braces if present
                    Write-Log "Looking for function: $functionName" -Level "DEBUG"
                    $functionToExecute = Get-Command $functionName -ErrorAction SilentlyContinue
                    if ($functionToExecute) {
                        $result = & $functionToExecute
                    }
                    else {
                        throw "Function not found: $functionName"
                    }
                }
        
                if ($null -eq $result) {
                    Write-Log "Warning: $($step.Name) returned no value, assuming success" -Level "WARN"
                    $result = $true
                }
        
                if ($result -eq $true) {
                    [void]$results.Successful.Add($step.Name)
                    $status[$step.Name] = "Success"
                    Write-Log "$($step.Name) installed successfully" -Level "SUCCESS"
                }
                elseif ($result -eq $false) {
                    [void]$results.Skipped.Add($step.Name)
                    $status[$step.Name] = "Skipped"
                    Write-Log "$($step.Name) was skipped" -Level "INFO"
                }
                else {
                    Write-Log "Unexpected return value from $($step.Name): $result" -Level "WARN"
                    # Determine status based on verification
                    if (Test-InstallationState $step.Name) {
                        [void]$results.Skipped.Add($step.Name)
                        $status[$step.Name] = "Skipped"
                    }
                    else {
                        [void]$results.Successful.Add($step.Name)
                        $status[$step.Name] = "Success"
                    }
                }
            }
            catch {
                [void]$results.Failed.Add($step.Name)
                $status[$step.Name] = "Failed"
                Write-Log "Failed to execute $($step.Name): $_" -Level "ERROR"
                
                if ($step.Required -and -not $Force) {
                    throw
                }
            }
        }

        # Show final summary
        Write-Host "`n╔════════════════════════════════════════════════════════════════╗"
        Write-Host "║                      Installation Summary                       ║"
        Write-Host "╠════════════════════════════════════════════════════════════════╣"
        Write-Host "║ Total Steps:    $($results.Total.ToString().PadRight(4)) ║"
        Write-Host "║ Successful:     $($results.Successful.Count.ToString().PadRight(4)) ║"
        Write-Host "║ Failed:         $($results.Failed.Count.ToString().PadRight(4)) ║"
        Write-Host "║ Skipped:        $($results.Skipped.Count.ToString().PadRight(4)) ║"
        Write-Host "╚════════════════════════════════════════════════════════════════╝"

        if ($results.Successful.Count -gt 0) {
            Write-Host "`nSuccessfully Completed:"
            foreach ($step in $results.Successful) {
                Write-Host "  • $step"
            }
        }
        
        if ($results.Skipped.Count -gt 0) {
            Write-Host "`nSkipped Steps:"
            foreach ($step in $results.Skipped) {
                Write-Host "  • $step"
            }
        }
        
        if ($results.Failed.Count -gt 0) {
            Write-Host "`nFailed Steps:" -ForegroundColor Red
            foreach ($step in $results.Failed) {
                Write-Host "  • $step" -ForegroundColor Red
            }
        }

        Write-Host "`nLog File: $script:SCRIPT_LOG_PATH"
        
        return $results
    }
    catch {
        Write-Log "Installation failed: $_" -Level "ERROR"
        throw
    }
}

# Export public functions
Export-ModuleMember -Function @(
    'Start-Installation',
    'Install-BasicPrograms',
    'Install-CliTools',
    'Install-GitSSH',
    'Install-Neovim',
    'Install-Node',
    'Install-PowerShellProfile',
    'Show-Summary',
    'Test-SystemRequirements'
)