#Requires -RunAsAdministrator
#Requires -Version 7

[CmdletBinding()]
param(
    [ValidateSet('Minimal', 'Standard', 'Full')]
    [string]$InstallationType = 'Standard',
    [switch]$Force,
    [switch]$NoBackup,
    [switch]$Silent = $true,
    [string]$LogPath
)

# Initialize error handling
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

try {
    Write-Host "Script root: $PSScriptRoot"
    
    # Load required helpers first
    $helpersDirPath = Join-Path $PSScriptRoot "helpers"
    $essentialHelpers = @(
        "Logging\Write-Log.ps1"
    )

    foreach ($helper in $essentialHelpers) {
        $helperPath = Join-Path $helpersDirPath $helper
        if (Test-Path $helperPath) {
            Write-Host "Loading helper: $helperPath"
            . $helperPath
        }
        else {
            throw "Essential helper not found: $helperPath"
        }
    }

    # Import module
    $modulePath = Join-Path $PSScriptRoot "WindowsSetup.psd1"
    if (-not (Test-Path $modulePath)) {
        throw "Module manifest not found at: $modulePath"
    }

    Write-Host "Importing module from: $modulePath"
    # Use -Force to ensure clean loading and -Global to ensure proper scope
    Import-Module $modulePath -Force -Global -DisableNameChecking
    
    # Start installation with parameters
    $params = @{
        InstallationType = $InstallationType
        Force            = $Force
        NoBackup         = $NoBackup
        Silent           = $Silent
    }
    
    if ($LogPath) {
        $params['LogPath'] = $LogPath
    }
    
    if ($DebugPreference -eq 'Continue') {
        $params['Debug'] = $true
    }

    $result = Start-Installation @params
    
    if (-not $result) {
        throw "Installation failed without specific error"
    }

    return $result
}
catch {
    Write-Error "Installation failed: $_"
    Write-Error $_.ScriptStackTrace
    exit 1
}