function Get-StoredCredential {
    param([string]$Purpose)
    
    $securePath = Join-Path $env:USERPROFILE ".setup_secure"
    $secureFile = Join-Path $securePath "$Purpose.cred"
    
    if (Test-Path $secureFile) {
        $secureData = Get-Content $secureFile | ConvertFrom-Json
        $password = $secureData.Password | ConvertTo-SecureString
        return New-Object PSCredential($secureData.Username, $password)
    }
    
    return $null
}