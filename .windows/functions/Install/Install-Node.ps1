function Install-Node {
    [CmdletBinding()]
    param()

    $didInstallSomething = $false

    try {
        Write-ColorOutput "Checking Node.js and pnpm installation..." "Status"

        if (Test-InstallationState "Node.js and pnpm") {
            Write-ColorOutput "Node.js and pnpm already installed" "Status"
            return $false
        }

        Write-ColorOutput "Installing Node.js and pnpm..." "Status"

        # Install Node.js if not present
        if (-not (Get-Command -Name node -ErrorAction SilentlyContinue)) {
            Invoke-SafeCommand {
                choco install nodejs-lts -y
            } -ErrorMessage "Failed to install Node.js"
            
            RefreshPath
            $didInstallSomething = $true

            if (-not (Get-Command -Name node -ErrorAction SilentlyContinue)) {
                throw "Node.js installation verification failed"
            }

            $nodeVersion = (node --version)
            Write-ColorOutput "Node.js $nodeVersion installed" "Success"
        }
        else {
            $nodeVersion = (node --version)
            Write-ColorOutput "Node.js $nodeVersion is already installed" "Status"
        }

        # Install pnpm if not present
        if (-not (Get-Command -Name pnpm -ErrorAction SilentlyContinue)) {
            Invoke-SafeCommand {
                npm install -g pnpm
            } -ErrorMessage "Failed to install pnpm"
            
            RefreshPath
            $didInstallSomething = $true

            if (-not (Get-Command -Name pnpm -ErrorAction SilentlyContinue)) {
                throw "pnpm installation verification failed"
            }

            $pnpmVersion = (pnpm --version)
            Write-ColorOutput "pnpm $pnpmVersion installed" "Success"
        }
        else {
            $pnpmVersion = (pnpm --version)
            Write-ColorOutput "pnpm $pnpmVersion is already installed" "Status"
        }

        # Install neovim package if not present
        if (-not (Get-Command -Name neovim -ErrorAction SilentlyContinue)) {
            Invoke-SafeCommand {
                npm install -g neovim
            } -ErrorMessage "Failed to install neovim package"
            
            RefreshPath
            $didInstallSomething = $true

            if (-not (Get-Command -Name neovim -ErrorAction SilentlyContinue)) {
                throw "neovim package installation verification failed"
            }

            Write-ColorOutput "neovim package installed" "Success"
        }
        else {
            Write-ColorOutput "neovim package is already installed" "Status"
        }

        if ($didInstallSomething) {
            Save-InstallationState "Node.js and pnpm"
            Write-ColorOutput "Node.js environment setup completed" "Success"
        }

        return $didInstallSomething
    }
    catch {
        # Restore backup if it exists
        if (Test-Path "$configPath.backup") {
            Move-Item "$configPath.backup" $configPath -Force
        }
          
        Handle-Error -ErrorRecord $_ `
            -ComponentName "Node" `
            -Operation "Installation" `
            -Critical
        throw
    }
}