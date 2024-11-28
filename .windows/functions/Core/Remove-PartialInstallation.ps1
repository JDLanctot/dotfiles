function Remove-PartialInstallation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$InstallInfo
    )
    
    try {
        Write-Log "Removing partial installation of $($InstallInfo.Component)" -Level "INFO"
        
        # Remove component files
        if (Test-Path $InstallInfo.Path) {
            Remove-Item $InstallInfo.Path -Recurse -Force
        }
        
        # Remove state files
        $stateFile = Join-Path $env:USERPROFILE ".${Component}_state.json"
        if (Test-Path $stateFile) {
            Remove-Item $stateFile -Force
        }
        
        # Remove from installed components list
        if ($script:INSTALLED_COMPONENTS.ContainsKey($InstallInfo.Component)) {
            $script:INSTALLED_COMPONENTS.Remove($InstallInfo.Component)
        }
        
        # Update installation state file
        $stateFilePath = "$env:USERPROFILE\.dotfiles_installed"
        if (Test-Path $stateFilePath) {
            $installed = Get-Content $stateFilePath | Where-Object { $_ -ne $InstallInfo.Component }
            $installed | Set-Content $stateFilePath
        }
        
        Write-Log "Successfully removed partial installation" -Level "SUCCESS"
        return $true
    }
    catch {
        Write-Log "Failed to remove partial installation: $_" -Level "ERROR"
        return $false
    }
}