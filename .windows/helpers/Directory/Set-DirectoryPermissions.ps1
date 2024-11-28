function Set-SecureDirectoryPermissions {
    param(
        [string]$Path,
        [string]$Owner = $env:USERNAME,
        [switch]$Inherit = $false
    )
    
    try {
        # Create directory if it doesn't exist
        if (-not (Test-Path $Path)) {
            New-Item -ItemType Directory -Path $Path -Force | Out-Null
        }

        # Get current ACL
        $acl = Get-Acl $Path
        
        # Remove inheritance
        $acl.SetAccessRuleProtection($true, $false)
        
        # Create new access rules
        $adminRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
            "Administrators",
            "FullControl",
            "ContainerInherit,ObjectInherit",
            "None",
            "Allow"
        )
        
        $systemRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
            "SYSTEM",
            "FullControl",
            "ContainerInherit,ObjectInherit",
            "None",
            "Allow"
        )
        
        $userRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
            $Owner,
            "Modify",
            "ContainerInherit,ObjectInherit",
            "None",
            "Allow"
        )
        
        # Clear existing rules and add new ones
        $acl.Access | ForEach-Object { $acl.RemoveAccessRule($_) }
        $acl.AddAccessRule($adminRule)
        $acl.AddAccessRule($systemRule)
        $acl.AddAccessRule($userRule)
        
        # Set owner
        $user = New-Object System.Security.Principal.NTAccount($Owner)
        $acl.SetOwner($user)
        
        # Apply ACL
        Set-Acl -Path $Path -AclObject $acl
        
        Write-Log "Successfully secured directory: $Path" -Level "SUCCESS"
        return $true
    }
    catch {
        Write-Log "Failed to secure directory ${Path}: $_" -Level "ERROR"
        return $false
    }
}