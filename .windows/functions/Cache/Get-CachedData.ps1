function Get-CachedData {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string]$Key,
        [int]$MaxAgeDays = 1
    )
    
    $cacheFile = Join-Path $script:CACHE_PATH "$Key.cache"
    if (-not (Test-Path $cacheFile)) { return $null }
    
    $cacheData = Get-Content $cacheFile | ConvertFrom-Json
    if ((Get-Date) - [DateTime]::Parse($cacheData.Timestamp) -gt [TimeSpan]::FromDays($MaxAgeDays)) {
        Remove-Item $cacheFile -Force
        return $null
    }
    
    return $cacheData.Data
}