
function New-SafeDirectory {
    param(
        [string]$Path,
        [switch]$Force
    )
    if (-not (Test-Path $Path)) {
        try {
            New-Item -ItemType Directory -Path $Path -Force:$Force -ErrorAction Stop
            Write-ColorOutput "Created directory: $Path" "Success"
        }
        catch {
            Write-ColorOutput "Failed to create directory: $Path - $_" "Error"
            return $false
        }
    }
    else {
        Write-ColorOutput "Directory already exists: $Path" "Status"
    }
    return $true
}