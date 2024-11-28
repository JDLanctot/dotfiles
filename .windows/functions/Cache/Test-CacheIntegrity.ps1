function Test-CacheIntegrity {
    [CmdletBinding()]
    param()
    
    try {
        $indexPath = Join-Path $script:CACHE_PATH "cache_index.json"
        $index = Get-Content $indexPath | ConvertFrom-Json -AsHashtable

        $results = @{
            TotalEntries    = $index.Entries.Count
            VerifiedEntries = 0
            MissingFiles    = @()
            CorruptedFiles  = @()
            OrphanedFiles   = @()
        }

        # Check indexed files exist and have correct hash
        foreach ($key in $index.Entries.Keys) {
            $cacheFile = Join-Path $script:CACHE_PATH "$key.cache"
            
            if (-not (Test-Path $cacheFile)) {
                $results.MissingFiles += $key
                continue
            }

            $fileHash = Get-FileHash -Path $cacheFile -Algorithm SHA256
            if ($fileHash.Hash -ne $index.Entries[$key].Hash) {
                $results.CorruptedFiles += $key
                continue
            }

            $results.VerifiedEntries++
        }

        # Check for files not in index
        $cacheFiles = Get-ChildItem $script:CACHE_PATH -File | 
        Where-Object { $_.Name -ne "cache_index.json" }
        
        foreach ($file in $cacheFiles) {
            $key = $file.BaseName
            if (-not $index.Entries.ContainsKey($key)) {
                $results.OrphanedFiles += $key
            }
        }

        return $results
    }
    catch {
        Write-Log "Failed to test cache integrity: $_" -Level "ERROR"
        return $null
    }
}