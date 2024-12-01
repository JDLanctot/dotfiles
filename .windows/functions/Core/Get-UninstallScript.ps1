function Get-UninstallScript {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Component
    )
    
    try {
        $uninstallPath = Join-Path $script:FUNCTIONS_ROOT "Uninstall\Uninstall-$Component.ps1"
        if (Test-Path $uninstallPath) {
            $scriptContent = Get-Content $uninstallPath -Raw
            return [ScriptBlock]::Create($scriptContent)
        }
        return $null
    }
    catch {
        Write-Log "Failed to verify $ComponentName installation" -Level "ERROR"
        return $null
    }
}
