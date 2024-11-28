function Get-CacheSize {
    [CmdletBinding()]
    param()
    
    try {
        $size = (Get-ChildItem $script:CACHE_PATH -File -Recurse | 
            Measure-Object -Property Length -Sum).Sum
        return $size
    }
    catch {
        Write-Log "Failed to get cache size: $_" -Level "ERROR"
        return 0
    }
}