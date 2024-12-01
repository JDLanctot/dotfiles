function Initialize-Dotfiles {
    if (Test-InstallationState "Dotfiles") {
        Write-ColorOutput "Dotfiles already configured" "Status"
        return $true
    }

    Write-ColorOutput "Setting up dotfiles..." "Status"

    # Use Join-Path for consistent path handling
    $tempPath = Join-Path $env:TEMP "dotfiles"
    if (Test-Path $tempPath) {
        Remove-Item $tempPath -Recurse -Force
    }

    try {
        # Clone using HTTPS to avoid SSH issues during initial setup
        git clone https://github.com/JDLanctot/dotfiles.git $tempPath

        # Install each configuration using the defined paths
        foreach ($configName in $CONFIG_PATHS.Keys) {
            Write-ColorOutput "Installing ${configName} configuration..." "Status"
            if (-not (Install-Configuration -Name $configName -TempPath $tempPath)) {
                throw "Failed to install ${configName} configuration"
            }
        }

        Save-InstallationState "Dotfiles"
        Write-ColorOutput "Dotfiles setup completed" "Success"
        return $true
    }
    catch {
        Write-ColorOutput "Failed to set up dotfiles: ${_}" "Error"
        return $false
    }
    finally {
        # Cleanup
        if (Test-Path $tempPath) {
            Remove-Item $tempPath -Recurse -Force
        }
    }
}