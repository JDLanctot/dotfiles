function Initialize-GitEnvironment {
    [CmdletBinding()]
    param()

    try {
        Write-ColorOutput "Checking Git environment..." "Status"

        # Check if Git is installed first
        if (-not (Get-Command -Name git -ErrorAction SilentlyContinue)) {
            Write-ColorOutput "Git is not installed. Please install Git first." "Error"
            return $false
        }

        # Check existing git configuration first
        $gitEmail = git config --global user.email
        $gitName = git config --global user.name

        if ($gitEmail -and $gitName) {
            Write-ColorOutput "Git already configured with:" "Status"
            Write-ColorOutput "Name: $gitName" "Status"
            Write-ColorOutput "Email: $gitEmail" "Status"
            
            # Store the existing configuration if not already stored
            if (-not (Get-StoredCredential -Purpose "git")) {
                $securePassword = ConvertTo-SecureString "placeholder" -AsPlainText -Force
                $gitCredential = New-Object PSCredential($gitName, $securePassword)
                $gitCredential | Add-Member -NotePropertyName Email -NotePropertyValue $gitEmail
                
                Protect-InstallationCredentials -Credential $gitCredential `
                    -Purpose "git" `
                    -Application "Git"
            }

            # Setup SSH directory if needed
            $sshDir = "$env:USERPROFILE\.ssh"
            if (-not (Test-Path $sshDir)) {
                New-Item -ItemType Directory -Path $sshDir -Force | Out-Null
                # Set appropriate permissions on .ssh directory
                $acl = Get-Acl $sshDir
                $acl.SetAccessRuleProtection($true, $false)
                $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
                    $env:USERNAME,
                    "FullControl",
                    "ContainerInherit,ObjectInherit",
                    "None",
                    "Allow"
                )
                $acl.AddAccessRule($rule)
                Set-Acl $sshDir $acl
                
                Save-InstallationState "Git Environment"
                return $true
            }

            return $false
        }

        $didConfigureSomething = $false

        # Get stored Git credentials or prompt for new ones
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
            $gitCredential = New-Object PSCredential($GIT_NAME, $securePassword)
            $gitCredential | Add-Member -NotePropertyName Email -NotePropertyValue $GIT_EMAIL
            
            Protect-InstallationCredentials -Credential $gitCredential `
                -Purpose "git" `
                -Application "Git"
        }

        # Configure Git
        Invoke-SafeCommand { 
            git config --global user.email $gitCredential.Email
            git config --global user.name $gitCredential.Username
            git config --global init.defaultBranch main
            git config --global core.autocrlf true
            git config --global credential.helper manager-core
        } -ErrorMessage "Failed to configure Git"
        
        $didConfigureSomething = $true

        # Setup SSH directory if needed
        $sshDir = "$env:USERPROFILE\.ssh"
        if (-not (Test-Path $sshDir)) {
            New-Item -ItemType Directory -Path $sshDir -Force | Out-Null
            # Set appropriate permissions on .ssh directory
            $acl = Get-Acl $sshDir
            $acl.SetAccessRuleProtection($true, $false)
            $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
                $env:USERNAME,
                "FullControl",
                "ContainerInherit,ObjectInherit",
                "None",
                "Allow"
            )
            $acl.AddAccessRule($rule)
            Set-Acl $sshDir $acl
            
            $didConfigureSomething = $true
        }

        if ($didConfigureSomething) {
            Save-InstallationState "Git Environment"
            Write-ColorOutput "Git environment setup completed" "Success"
        }

        return $didConfigureSomething
    }
    catch {
        Handle-Error -ErrorRecord $_ `
            -ComponentName "Git Environment" `
            -Operation "Setup" `
            -Critical
        throw
    }
}