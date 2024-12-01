function Save-InstallationState {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Component,
        [hashtable]$AdditionalData
    )
    
    try {
        # Get state file path
        $stateFile = "$env:USERPROFILE\.dotfiles_installed"
        $stateDir = Split-Path $stateFile -Parent
        
        # Create state directory if it doesn't exist
        if (-not (Test-Path $stateDir)) {
            New-Item -ItemType Directory -Path $stateDir -Force | Out-Null
        }
        
        # Update components registry
        $script:INSTALLED_COMPONENTS[$Component] = @{
            InstalledOn = Get-Date
            Version     = Get-ComponentVersion -Component $Component
            Path        = Get-ComponentPath -Component $Component
            Data        = $AdditionalData
        }
        
        # Save to state file
        $Component | Add-Content -Path $stateFile
        
        # Create component-specific state if needed
        $componentState = Join-Path $stateDir ".${Component}_state.json"
        if ($AdditionalData) {
            $AdditionalData | ConvertTo-Json | Set-Content -Path $componentState
        }
        
        Write-Log "Saved installation state for $Component" -Level "SUCCESS"
        return $true
    }
    catch {
        Write-Log "Failed to verify $ComponentName installation" -Level "ERROR"
        return $false
    }
}