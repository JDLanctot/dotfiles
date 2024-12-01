function Install-Miniconda {
    [CmdletBinding()]
    param()

    $didInstallSomething = $false
    $anacondaPath = "C:\ProgramData\anaconda3"
    $minicondaPath = "$env:USERPROFILE\Miniconda3"

    try {
        Write-ColorOutput "Checking Conda installation..." "Status"

        # Check for existing installations
        $hasAnaconda = Test-Path "$anacondaPath\Scripts\conda.exe"
        $hasMiniconda = Test-Path "$minicondaPath\Scripts\conda.exe"
        $hasCommand = Get-Command -Name conda -ErrorAction SilentlyContinue

        if (Test-InstallationState "Miniconda") {
            Write-ColorOutput "Conda already installed and configured" "Status"
            return $false
        }

        Write-ColorOutput "Installing Conda..." "Status"

        # Only install if neither Anaconda nor Miniconda is present
        if (-not ($hasAnaconda -or $hasMiniconda -or $hasCommand)) {
            # Download Miniconda installer
            $installerUrl = "https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe"
            $installerPath = Join-Path $env:TEMP "miniconda.exe"
            
            Write-ColorOutput "Downloading Miniconda installer..." "Status"
            
            try {
                Invoke-SafeCommand { 
                    Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath -UseBasicParsing
                } -ErrorMessage "Failed to download Miniconda installer"
            }
            catch {
                # Fallback to curl if WebRequest fails
                Write-ColorOutput "Trying alternative download method..." "Status"
                Invoke-SafeCommand { 
                    curl.exe $installerUrl -o $installerPath 
                } -ErrorMessage "Failed to download Miniconda installer using curl"
            }

            if (-not (Test-Path $installerPath)) {
                throw "Installer download failed"
            }

            # Install Miniconda silently
            Write-ColorOutput "Installing Miniconda (this may take a few minutes)..." "Status"
            $installArgs = @(
                "/S", # Silent installation
                "/AddToPath=1", # Add to PATH
                "/RegisterPython=1", # Register as system Python
                "/D=$minicondaPath"  # Installation directory
            )
            
            $result = Start-Process -FilePath $installerPath -ArgumentList $installArgs -Wait -PassThru
            if ($result.ExitCode -ne 0) {
                throw "Installation failed with exit code: $($result.ExitCode)"
            }

            # Clean up installer
            Remove-Item $installerPath -Force -ErrorAction SilentlyContinue
            
            $didInstallSomething = $true

            # Refresh environment variables
            RefreshPath
            
            # Verify installation
            if (-not (Get-Command conda -ErrorAction SilentlyContinue)) {
                throw "Conda command not found after installation"
            }
        }

        # Determine which conda to use for initialization
        $condaPath = if ($hasAnaconda) { $anacondaPath } else { $minicondaPath }

        # Initialize conda for PowerShell if not already initialized
        Write-ColorOutput "Checking conda initialization..." "Status"
        
        if (-not (Test-Path $PROFILE) -or -not (Select-String -Path $PROFILE -Pattern "conda.*initialize" -Quiet)) {
            Write-ColorOutput "Initializing conda for PowerShell..." "Status"
            
            # Create a temporary script to run conda init
            $initScript = Join-Path $env:TEMP "conda-init.ps1"
            @"
If (Test-Path "$condaPath\Scripts\conda.exe") {
    (& "$condaPath\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{`$_} | Invoke-Expression
}
"@ | Set-Content $initScript

            # Execute the init script in a new PowerShell process
            $initResult = Start-Process powershell -ArgumentList "-File `"$initScript`"" -Wait -PassThru
            if ($initResult.ExitCode -ne 0) {
                throw "Conda initialization failed"
            }

            # Clean up
            Remove-Item $initScript -Force -ErrorAction SilentlyContinue
            $didInstallSomething = $true

            Write-ColorOutput "Conda initialization completed" "Success"
        }

        if ($didInstallSomething) {
            Save-InstallationState "Miniconda"
            Write-ColorOutput "Conda installation completed" "Success"
            Write-ColorOutput "Please restart your terminal to use conda" "Status"
            return $true
        }
        else {
            Write-ColorOutput "Conda was already properly configured" "Status"
            return $false
        }
    }
    catch {
        # Restore backup if it exists
        if (Test-Path "$configPath.backup") {
            Move-Item "$configPath.backup" $configPath -Force
        }
          
        Handle-Error -ErrorRecord $_ `
            -ComponentName "Conda" `
            -Operation "Installation" `
            -Critical
        throw
    }
}