function Test-FileInUse {
    param([string]$Path)

    if (-not (Get-Variable -Name 'HELPERS_ROOT' -Scope Script -ErrorAction SilentlyContinue)) {
        throw "Module is not properly initialized. HELPERS_ROOT is not defined."
    }
    
    
    try {
        $fileInfo = New-Object System.IO.FileInfo $Path
        $stream = $fileInfo.Open([System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None)
        if ($stream) {
            $stream.Close()
            return $false
        }
    }
    catch {
        return $true
    }
    return $true
}