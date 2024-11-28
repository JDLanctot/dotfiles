function Optimize-Cache {
    param(
        [int64]$MaxCacheSize = 1GB,
        [int]$MaxAge = 7
    )
    
    $cacheItems = Get-ChildItem $script:CACHE_PATH |
    Sort-Object LastWriteTime -Descending
    
    $totalSize = ($cacheItems | Measure-Object Length -Sum).Sum
    
    while ($totalSize -gt $MaxCacheSize) {
        $oldest = $cacheItems | Select-Object -Last 1
        Remove-Item $oldest.FullName -Force
        $totalSize -= $oldest.Length
    }
}