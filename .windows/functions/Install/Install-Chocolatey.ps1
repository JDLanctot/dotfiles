# Function to install Chocolatey
function Install-Chocolatey {
    Write-ColorOutput "Installing Chocolatey..." "Status"
    if (-not (Get-Command -Name choco -ErrorAction SilentlyContinue)) {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        Write-ColorOutput "Chocolatey installed successfully" "Success"
    }
    else {
        Write-ColorOutput "Chocolatey is already installed" "Status"
    }
}
