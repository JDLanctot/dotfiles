function Clear-CachedData {
    [CmdletBinding()]
    param(
        [int]$OlderThan = 7,
        [ValidateSet('Age', 'Size', 'Priority')]
        [string]$Strategy = 'Age',
        [int64]$TargetSize = 500MB
    )
    
    try {
        # Validate cache is initialized
        if (-not $script:CACHE_PATH -or -not (Test-Path $script:CACHE_PATH)) {
            throw "Cache not initialized"
        }

        $indexPath = Join-Path $script:CACHE_PATH "cache_index.json"
        $index = Get-Content $indexPath | ConvertFrom-Json -AsHashtable

        $itemsToRemove = @()

        switch ($Strategy) {
            'Age' {
                $cutoffDate = (Get-Date).AddDays(-$OlderThan)
                $itemsToRemove = $index.Entries.Keys | Where-Object {
                    [DateTime]::Parse($index.Entries[$_].Timestamp) -lt $cutoffDate
                }
            }
            'Size' {
                $currentSize = Get-CacheSize
                if ($currentSize -gt $TargetSize) {
                    # Sort by size and remove largest files first
                    $itemsToRemove = $index.Entries.Keys | 
                    Sort-Object { $index.Entries[$_].Size } -Descending |
                    Select-Object -First ([math]::Ceiling(($currentSize - $TargetSize) / 100MB))
                }
            }
            'Priority' {
                # Remove low priority items first, then medium if needed
                $priorities = @('Low', 'Medium')
                foreach ($priority in $priorities) {
                    $itemsToRemove += $index.Entries.Keys | Where-Object {
                        $index.Entries[$_].Priority -eq $priority
                    }
                    if ((Get-CacheSize) -le $TargetSize) {
                        break
                    }
                }
            }
        }

        # Remove items and update index
        foreach ($key in $itemsToRemove) {
            $cacheFile = Join-Path $script:CACHE_PATH "$key.cache"
            if (Test-Path $cacheFile) {
                Remove-Item $cacheFile -Force
            }
            $index.Entries.Remove($key)
        }

        # Update index file
        $index.LastCleaned = Get-Date
        $index | ConvertTo-Json | Set-Content $indexPath

        Write-Log "Cleaned $($itemsToRemove.Count) cache entries" -Level "INFO"
        return $true
    }
    catch {
        Write-Log "Failed to clear cache: $_" -Level "ERROR"
        return $false
    }
}