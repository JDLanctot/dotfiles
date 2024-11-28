function Get-InstallationSteps {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('Minimal', 'Standard', 'Full')]
        [string]$Type
    )
    
    try {
        # Get profile configuration
        $profile = $script:Config.InstallationProfiles[$Type]
        if (-not $profile) {
            throw "Installation profile not found: $Type"
        }
        
        # Get base steps
        $steps = $profile.Steps
        
        # If profile inherits from another, merge steps
        if ($profile.InheritFrom) {
            $baseProfile = $script:Config.InstallationProfiles[$profile.InheritFrom]
            if ($baseProfile) {
                $baseSteps = $baseProfile.Steps
                $steps = Merge-InstallationSteps -BaseSteps $baseSteps -NewSteps $steps
            }
        }
        
        # Make all steps required if specified
        if ($profile.MakeAllRequired) {
            $steps = $steps | ForEach-Object {
                @{
                    Name     = $_.Name
                    Function = $_.Function
                    Required = $true
                }
            }
        }
        
        return $steps
    }
    catch {
        Write-Log "Failed to get installation steps: $_" -Level "ERROR"
        return $null
    }
}