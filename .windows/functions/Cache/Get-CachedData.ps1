function Get-CachedData {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Key,
        [switch]$AllowExpired,
        [int]$MaxAgeDays = 1
    )
    
    try {
        # Validate cache is initialized
        if (-not $script:CACHE_PATH -or -not (Test-Path $script:CACHE_PATH)) {
            throw "Cache not initialized"
        }

        $cacheFile = Join-Path $script:CACHE_PATH "$Key.cache"
        $indexPath = Join-Path $script:CACHE_PATH "cache_index.json"
        
        if (-not (Test-Path $cacheFile)) {
            Write-Log "Cache miss for $Key" -Level "DEBUG"
            return $null
        }

        # Load cache index
        $index = Get-Content $indexPath | ConvertFrom-Json -AsHashtable
        
        # Check if entry exists in index
        if (-not $index.Entries.ContainsKey($Key)) {
            Write-Log "Cache entry not found in index for $Key" -Level "WARN"
            return $null
        }

        $entry = $index.Entries[$Key]
        $cacheAge = (Get-Date) - [DateTime]::Parse($entry.Timestamp)
        
        # Check if cache is expired
        if (-not $AllowExpired -and $cacheAge.TotalDays -gt $MaxAgeDays) {
            Write-Log "Cache expired for $Key" -Level "DEBUG"
            return $null
        }

        # Verify cache integrity
        $fileHash = Get-FileHash -Path $cacheFile -Algorithm SHA256
        if ($fileHash.Hash -ne $entry.Hash) {
            Write-Log "Cache integrity check failed for $Key" -Level "WARN"
            Remove-Item $cacheFile -Force
            $index.Entries.Remove($Key)
            $index | ConvertTo-Json | Set-Content $indexPath
            return $null
        }

        # Load and return cached data
        $cacheData = Get-Content $cacheFile | ConvertFrom-Json -AsHashtable
        Write-Log "Cache hit for $Key" -Level "DEBUG"
        return $cacheData.Data
    }
    catch {
        Write-Log "Failed to retrieve cached data for $(Key): $_" -Level "ERROR"
        return $null
    }
}