function Install-NerdFonts {
    [CmdletBinding()]
    param()

    $didInstallSomething = $false

    try {
        Write-ColorOutput "Checking NerdFonts installation..." "Status"

        if (Test-InstallationState "nerdfonts") {
            Write-ColorOutput "JetBrainsMono Nerd Font already installed" "Status"
            return $false
        }

        Write-ColorOutput "Installing JetBrainsMono Nerd Font..." "Status"

        $fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip"
        $fontsFolder = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
        $downloadPath = "$env:TEMP\JetBrainsMono.zip"
        $extractPath = "$env:TEMP\JetBrainsMono"

        # Create fonts folder if it doesn't exist
        if (-not (Test-Path $fontsFolder)) {
            New-Item -ItemType Directory -Path $fontsFolder -Force | Out-Null
        }

        # Download and extract font
        Invoke-SafeCommand {
            Invoke-WebRequest -Uri $fontUrl -OutFile $downloadPath
            Expand-Archive -Path $downloadPath -DestinationPath $extractPath -Force
        } -ErrorMessage "Failed to download or extract font"

        try {
            # Install fonts
            $fonts = Get-ChildItem -Path $extractPath -Filter "*.ttf"
            $installedCount = 0

            foreach ($font in $fonts) {
                $targetPath = Join-Path $fontsFolder $font.Name
                if (-not (Test-Path $targetPath)) {
                    Copy-Item $font.FullName $targetPath
                    $installedCount++
                }
            }

            if ($installedCount -gt 0) {
                $didInstallSomething = $true
                Write-ColorOutput "$installedCount fonts installed successfully" "Success"
                Save-InstallationState "nerdfonts"
            }
            else {
                Write-ColorOutput "No new fonts needed to be installed" "Status"
            }
        }
        finally {
            # Cleanup
            if (Test-Path $downloadPath) {
                Remove-Item $downloadPath -Force
            }
            if (Test-Path $extractPath) {
                Remove-Item $extractPath -Recurse -Force
            }
        }

        return $didInstallSomething
    }
    catch {
        # Restore backup if it exists
        if (Test-Path "$configPath.backup") {
            Move-Item "$configPath.backup" $configPath -Force
        }
          
        Handle-Error -ErrorRecord $_ `
            -ComponentName "NerdFonts" `
            -Operation "Installation" `
            -Critical
        throw
    }
}