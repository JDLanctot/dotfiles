function Install-Miniconda {
    [CmdletBinding()]
    param()

    $didInstallSomething = $false

    try {
        Write-ColorOutput "Checking Miniconda installation..." "Status"

        if (Test-InstallationState "miniconda") {
            Write-ColorOutput "Miniconda already installed and configured" "Status"
            return $false
        }

        Write-ColorOutput "Installing Miniconda..." "Status"

        # Check if conda is already installed
        if (-not (Get-Command conda -ErrorAction SilentlyContinue)) {
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
                "/D=$env:USERPROFILE\Miniconda3"  # Installation directory
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

        # Initialize conda for PowerShell if not already initialized
        Write-ColorOutput "Checking conda initialization..." "Status"
        
        if (-not (Test-Path $PROFILE) -or -not (Select-String -Path $PROFILE -Pattern "conda initialize" -Quiet)) {
            Write-ColorOutput "Initializing conda for PowerShell..." "Status"
            
            # Create a temporary script to run conda init
            $initScript = Join-Path $env:TEMP "conda-init.ps1"
            @"
`$env:Path = "${env:USERPROFILE}\Miniconda3;${env:USERPROFILE}\Miniconda3\Scripts;${env:USERPROFILE}\Miniconda3\Library\bin;$env:Path"
conda init powershell
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
            Save-InstallationState "miniconda"
            Write-ColorOutput "Miniconda installation completed" "Success"
            Write-ColorOutput "Please restart your terminal to use conda" "Status"
        }
        else {
            Write-ColorOutput "Miniconda was already properly configured" "Status"
        }

        return $didInstallSomething
    }
    catch {
        # Restore backup if it exists
        if (Test-Path "$configPath.backup") {
            Move-Item "$configPath.backup" $configPath -Force
        }
          
        Handle-Error -ErrorRecord $_ `
            -ComponentName "MiniConda" `
            -Operation "Installation" `
            -Critical
        throw
    }
}