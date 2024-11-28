function Test-PathInUse {
    param([string]$Path)

    if (-not (Get-Variable -Name 'HELPERS_ROOT' -Scope Script -ErrorAction SilentlyContinue)) {
        throw "Module is not properly initialized. HELPERS_ROOT is not defined."
    }
    
    
    try {
        if (Test-Path $Path) {
            $item = Get-Item $Path
            if ($item.PSIsContainer) {
                # For directories, check if any files are in use
                $files = Get-ChildItem $Path -Recurse -File
                foreach ($file in $files) {
                    $inUse = Test-FileInUse $file.FullName
                    if ($inUse) { return $true }
                }
                return $false
            }
            else {
                # For files, check directly
                return Test-FileInUse $Path
            }
        }
        return $false
    }
    catch {
        Write-Log "Failed to check if path is in use: $_" -Level "ERROR"
        return $true # Assume in use if check fails
    }
}