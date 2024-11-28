function Start-NetworkOperation {
    param(
        [Parameter(Mandatory = $true)]
        [scriptblock]$Operation,
        [string]$Description = "network operation",
        [int]$MaxRetries = 3,
        [int]$RetryDelaySeconds = 5,
        [switch]$UseCache,
        [string]$CacheKey
    )
    
    # Check cache if requested
    if ($UseCache -and $CacheKey) {
        $cachedResult = Get-CachedData -Key $CacheKey
        if ($cachedResult) {
            Write-Log "Using cached data for $Description" -Level "INFO"
            return $cachedResult
        }
    }
    
    $attempt = 1
    $lastError = $null
    
    do {
        try {
            # Test network connection before operation
            if (-not (Test-NetworkConnectivity)) {
                throw "No network connectivity"
            }
            
            # Execute the operation
            $result = & $Operation
            
            # Cache successful result if requested
            if ($UseCache -and $CacheKey) {
                Save-CachedData -Key $CacheKey -Data $result
            }
            
            return $result
        }
        catch {
            $lastError = $_
            Write-Log "Attempt $attempt of $MaxRetries for $Description failed: $_" -Level "WARN"
            
            if ($attempt -ge $MaxRetries) {
                # Use cached data as fallback if available
                if ($UseCache -and $CacheKey) {
                    $cachedResult = Get-CachedData -Key $CacheKey -AllowExpired
                    if ($cachedResult) {
                        Write-Log "Using expired cached data as fallback for $Description" -Level "WARN"
                        return $cachedResult
                    }
                }
                throw "Failed after $MaxRetries attempts: $lastError"
            }
            
            # Implement exponential backoff
            $delay = $RetryDelaySeconds * [Math]::Pow(2, $attempt - 1)
            Start-Sleep -Seconds $delay
            $attempt++
        }
    } while ($true)
}
