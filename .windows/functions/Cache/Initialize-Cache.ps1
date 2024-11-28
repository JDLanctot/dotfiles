function Initialize-Cache {
    [CmdletBinding()]
    param(
        [string]$CachePath = (Join-Path $env:TEMP "WindowsSetup\Cache"),
        [switch]$Force
    )
    
    try {
        # Create cache directory if it doesn't exist
        if (-not (Test-Path $CachePath)) {
            New-Item -ItemType Directory -Path $CachePath -Force | Out-Null
        }

        # Create cache index file
        $indexPath = Join-Path $CachePath "cache_index.json"
        if ($Force -or -not (Test-Path $indexPath)) {
            @{
                CreatedOn   = Get-Date
                LastCleaned = Get-Date
                Entries     = @{}
            } | ConvertTo-Json | Set-Content $indexPath
        }

        # Set script-wide cache path
        $script:CACHE_PATH = $CachePath

        # Clean old cache entries
        Clear-CachedData -OlderThan 7

        Write-Log "Cache initialized at $CachePath" -Level "SUCCESS"
        return $true
    }
    catch {
        Write-Log "Failed to initialize cache: $_" -Level "ERROR"
        return $false
    }
}
