function Save-CachedData {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Key,
        [Parameter(Mandatory = $true)]
        $Data,
        [hashtable]$Metadata = @{},
        [ValidateSet('High', 'Medium', 'Low')]
        [string]$Priority = 'Medium'
    )
    
    try {
        # Validate cache is initialized
        if (-not $script:CACHE_PATH -or -not (Test-Path $script:CACHE_PATH)) {
            throw "Cache not initialized"
        }

        # Prepare cache data
        $cacheData = @{
            Data      = $Data
            Metadata  = $Metadata
            Timestamp = Get-Date
            Priority  = $Priority
        }

        # Save cache file
        $cacheFile = Join-Path $script:CACHE_PATH "$Key.cache"
        $cacheData | ConvertTo-Json -Depth 10 | Set-Content $cacheFile

        # Update index
        $indexPath = Join-Path $script:CACHE_PATH "cache_index.json"
        $index = Get-Content $indexPath | ConvertFrom-Json -AsHashtable
        
        $fileHash = Get-FileHash -Path $cacheFile -Algorithm SHA256
        $index.Entries[$Key] = @{
            Timestamp = $cacheData.Timestamp
            Hash      = $fileHash.Hash
            Priority  = $Priority
            Size      = (Get-Item $cacheFile).Length
        }

        $index | ConvertTo-Json | Set-Content $indexPath

        # Check cache size and clean if needed
        if ((Get-CacheSize) -gt 1GB) {
            Clear-CachedData -Strategy Priority
        }

        Write-Log "Cached data saved for $Key" -Level "DEBUG"
        return $true
    }
    catch {
        Write-Log "Failed to cache data for $(Key): $_" -Level "ERROR"
        return $false
    }
}