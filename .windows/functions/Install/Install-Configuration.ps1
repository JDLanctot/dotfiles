function Install-Configuration {
    param(
        [string]$Name,
        [string]$TempPath
    )

    if (-not $CONFIG_PATHS.ContainsKey($Name)) {
        Write-ColorOutput "Unknown configuration: ${Name}" "Error"
        return $false
    }

    $config = $CONFIG_PATHS[$Name]
    $sourcePath = Join-Path $TempPath $config.source
    $targetPath = $config.target

    # Create target directory if it doesn't exist
    $targetDir = Split-Path $targetPath -Parent
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }

    # Backup existing configuration
    $backupPath = Backup-Configuration -Path $targetPath -Type $config.type

    try {
        if (Test-Path $sourcePath) {
            if ($config.type -eq 'directory') {
                if (Test-Path $targetPath) {
                    Remove-Item $targetPath -Recurse -Force
                }
                Copy-Item $sourcePath $targetPath -Recurse -Force
            }
            else {
                Copy-Item $sourcePath $targetPath -Force
            }
            Write-ColorOutput "${Name} configuration installed" "Success"
            return $true
        }
        else {
            Write-ColorOutput "${Name} configuration not found in dotfiles" "Error"
            if ($backupPath) {
                Restore-Configuration -BackupPath $backupPath -TargetPath $targetPath -Type $config.type
            }
            return $false
        }
    }
    catch {
        Write-ColorOutput "Failed to install ${Name} configuration: ${_}" "Error"
        if ($backupPath) {
            Restore-Configuration -BackupPath $backupPath -TargetPath $targetPath -Type $config.type
        }
        return $false
    }
}