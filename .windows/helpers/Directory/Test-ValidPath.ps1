function Test-ValidPath {
    param(
        [string]$Path,
        [switch]$RequireDirectory,
        [switch]$RequireFile,
        [switch]$CreateIfNotExist
    )
    
    try {
        # Check if path is valid
        if ([string]::IsNullOrWhiteSpace($Path)) {
            throw "Path is null or empty"
        }

        # Check for invalid characters
        $invalidChars = [System.IO.Path]::GetInvalidPathChars()
        if ($Path.IndexOfAny($invalidChars) -ge 0) {
            throw "Path contains invalid characters"
        }

        # Check if path exists
        if (Test-Path $Path) {
            $item = Get-Item $Path
            
            # Validate item type
            if ($RequireDirectory -and -not $item.PSIsContainer) {
                throw "Path exists but is not a directory"
            }
            if ($RequireFile -and $item.PSIsContainer) {
                throw "Path exists but is not a file"
            }
            
            return $true
        }
        elseif ($CreateIfNotExist) {
            if ($RequireDirectory) {
                New-Item -ItemType Directory -Path $Path -Force | Out-Null
            }
            elseif ($RequireFile) {
                New-Item -ItemType File -Path $Path -Force | Out-Null
            }
            return $true
        }
        
        return $false
    }
    catch {
        Write-Log "Invalid path ${Path}: $_" -Level "ERROR"
        return $false
    }
}