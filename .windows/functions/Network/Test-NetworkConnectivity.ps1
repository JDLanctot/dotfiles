function Test-NetworkConnectivity {
    $testUrls = @(
        "github.com",
        "raw.githubusercontent.com",
        "api.github.com"
    )
    
    foreach ($url in $testUrls) {
        try {
            $response = Test-NetConnection -ComputerName $url -Port 443 -WarningAction SilentlyContinue
            if ($response.TcpTestSucceeded) {
                return $true
            }
        }
        catch {
            Write-Log "Network test failed for ${url}: $_" -Level "DEBUG"
        }
    }
    
    return $false
}