function Test-RequiredPermissions {
    param([string[]]$Paths)

    if (-not (Get-Variable -Name 'HELPERS_ROOT' -Scope Script -ErrorAction SilentlyContinue)) {
        throw "Module is not properly initialized. HELPERS_ROOT is not defined."
    }
    
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    
    foreach ($path in $Paths) {
        $acl = Get-Acl $path
        $hasAccess = $false
        
        foreach ($access in $acl.Access) {
            if ($principal.IsInRole($access.IdentityReference)) {
                if ($access.FileSystemRights.HasFlag([Security.AccessControl.FileSystemRights]::Modify)) {
                    $hasAccess = $true
                    break
                }
            }
        }
        
        if (-not $hasAccess) {
            throw "Insufficient permissions for path: $path"
        }
    }
}