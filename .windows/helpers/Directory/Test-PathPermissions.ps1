function Test-PathPermissions {
    param(
        [string]$Path,
        [string[]]$RequiredPermissions = @('Write', 'Modify')
    )
    
    try {
        # Get current user's identity
        $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = New-Object System.Security.Principal.WindowsPrincipal($currentUser)
        
        # Get path's ACL
        $acl = Get-Acl $Path -ErrorAction Stop
        
        # Check if user has required permissions
        foreach ($accessRule in $acl.Access) {
            if ($accessRule.IdentityReference.Value -eq $currentUser.Name -or
                ($principal.IsInRole($accessRule.IdentityReference.Value))) {
                
                $hasRequired = $true
                foreach ($required in $RequiredPermissions) {
                    if (-not $accessRule.FileSystemRights.HasFlag([System.Security.AccessControl.FileSystemRights]::$required)) {
                        $hasRequired = $false
                        break
                    }
                }
                
                if ($hasRequired) {
                    return $true
                }
            }
        }
        
        return $false
    }
    catch {
        Write-Log "Failed to check permissions for ${Path}: $_" -Level "ERROR"
        return $false
    }
}