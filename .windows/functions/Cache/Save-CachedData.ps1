function Save-CachedData {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string]$Key,
        [Parameter(Mandatory = $true)]$Data
    )
    
    $cacheData = @{
        Data      = $Data
        Timestamp = Get-Date
    }
    
    $cacheFile = Join-Path $script:CACHE_PATH "$Key.cache"
    $cacheData | ConvertTo-Json | Set-Content $cacheFile
    return $true
}