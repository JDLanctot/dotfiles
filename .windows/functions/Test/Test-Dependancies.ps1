function Test-Dependencies {
    param(
        [string[]]$RequiredModules,
        [hashtable]$RequiredCommands
    )

    if (-not (Get-Variable -Name 'HELPERS_ROOT' -Scope Script -ErrorAction SilentlyContinue)) {
        throw "Module is not properly initialized. HELPERS_ROOT is not defined."
    }

    $missing = @()

    foreach ($module in $RequiredModules) {
        if (-not (Get-Module -ListAvailable -Name $module)) {
            $missing += "Module: ${module}"
        }
    }

    foreach ($command in $RequiredCommands.Keys) {
        if (-not (Get-Command -Name $command -ErrorAction SilentlyContinue)) {
            $version = $RequiredCommands[$command]
            $missing += "Command: ${command} (Required version: ${version})"
        }
    }

    if ($missing.Count -gt 0) {
        Write-Log "Missing dependencies:`n$($missing -join "`n")" -Level "ERROR"
        return $false
    }

    return $true
}