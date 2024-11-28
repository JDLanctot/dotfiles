function Protect-InstallationCredentials {
    param(
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]$Credential,
        [string]$Purpose,
        [string]$Application
    )
    
    try {
        # Create credential target
        $target = "WindowsSetup_${Purpose}_${Application}"
        
        # Store in Windows Credential Manager
        cmdkey /generic:$target /user:$($Credential.UserName) /pass:$($Credential.GetNetworkCredential().Password)
        
        # Create secure metadata
        $metadata = @{
            Purpose     = $Purpose
            Application = $Application
            Created     = Get-Date
            Username    = $Credential.UserName
        }
        
        # Store metadata securely
        $secureMetadata = ConvertTo-SecureString (ConvertTo-Json $metadata) -AsPlainText -Force
        [System.Environment]::SetEnvironmentVariable(
            "WindowsSetup_${target}_Meta",
            $secureMetadata,
            [System.EnvironmentVariableTarget]::User
        )
        
        return $true
    }
    catch {
        Write-Log "Failed to protect credentials: $_" -Level "ERROR"
        return $false
    }
}