function Install-GitSSH {
    [CmdletBinding()]
    param()

    try {
        if (Test-InstallationState "git_ssh") {
            Write-ColorOutput "Git and SSH already configured" "Status"
            return $true
        }

        Write-ColorOutput "Checking Git configuration..." "Status"

        # Check if git is installed first
        if (-not (Get-Command -Name git -ErrorAction SilentlyContinue)) {
            Write-ColorOutput "Git is not installed. Please install Git first." "Error"
            return $false
        }

        # Check existing git configuration
        $gitEmail = git config --global user.email
        $gitName = git config --global user.name

        if ($gitEmail -and $gitName) {
            Write-ColorOutput "Git already configured with:" "Status"
            Write-ColorOutput "Name: $gitName" "Status"
            Write-ColorOutput "Email: $gitEmail" "Status"
            
            # Store the existing configuration
            $securePassword = ConvertTo-SecureString "placeholder" -AsPlainText -Force
            $gitCredential = New-Object System.Management.Automation.PSCredential($gitName, $securePassword)
            $gitCredential | Add-Member -NotePropertyName Email -NotePropertyValue $gitEmail
            
            Protect-InstallationCredentials -Credential $gitCredential `
                -Purpose "git" `
                -Application "Git"

            Save-InstallationState "git_ssh"
            return $true
        }

        Write-ColorOutput "Setting up Git configuration..." "Status"

        # Get Git credentials
        $gitCredential = $null
        $storedCred = Get-StoredCredential -Purpose "git"
        
        if ($storedCred) {
            Write-ColorOutput "Found stored Git credentials" "Status"
            $gitCredential = $storedCred
        }
        else {
            $GIT_EMAIL = Read-Host "Enter your Git email"
            $GIT_NAME = Read-Host "Enter your Git name"
            
            if ([string]::IsNullOrWhiteSpace($GIT_EMAIL) -or [string]::IsNullOrWhiteSpace($GIT_NAME)) {
                Write-ColorOutput "Git email and name are required" "Error"
                return $false
            }
            
            # Store credentials securely
            $securePassword = ConvertTo-SecureString "placeholder" -AsPlainText -Force
            $gitCredential = New-Object System.Management.Automation.PSCredential($GIT_NAME, $securePassword)
            $gitCredential | Add-Member -NotePropertyName Email -NotePropertyValue $GIT_EMAIL
            
            Protect-InstallationCredentials -Credential $gitCredential `
                -Purpose "git" `
                -Application "Git"
        }

        # Configure Git using stored credentials
        Invoke-SafeCommand { 
            git config --global user.email $gitCredential.Email
            git config --global user.name $gitCredential.Username
            git config --global init.defaultBranch main
            git config --global core.autocrlf true
            git config --global credential.helper manager-core
        } -ErrorMessage "Failed to configure Git"

        Save-InstallationState "git_ssh"
        Write-ColorOutput "Git configuration completed" "Success"
        return $true
    }
    catch {
        Write-ColorOutput "Failed to configure Git: $_" "Error"
        return $false
    }
}