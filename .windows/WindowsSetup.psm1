# Initialize empty module state
$script:Config = $null
$script:CONFIG_PATHS = $null
$script:INSTALLED_COMPONENTS = @{}
$script:InstallationState = $null
$script:Progress = $null

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
    "ProgressUI.ps1"
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

# Export public functions
Export-ModuleMember -Function @(
    'Start-Installation',
    'Install-BasicPrograms',
    'Install-CliTools',
    'Install-GitEnvironment',
    'Install-Neovim',
    'Install-Node',
    'Install-PowerShellProfile',
    'Show-Summary',
    'Test-SystemRequirements'
)