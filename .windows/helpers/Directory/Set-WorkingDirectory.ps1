function Set-WorkingDirectory {
    param (
        [string]$Path
    )
    try {
        Push-Location $Path
        return $true
    }
    catch {
        Write-ColorOutput "Failed to change directory to ${Path}" "Error"
        return $false
    }
}