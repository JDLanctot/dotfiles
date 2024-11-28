function Initialize-DevelopmentCredentials {
    [CmdletBinding()]
    param(
        [switch]$Force
    )
    
    try {
        # Check if Git is installed and configured
        if (Get-Command -Name git -ErrorAction SilentlyContinue) {
            $gitEmail = git config --global user.email
            $gitName = git config --global user.name

            if ($gitEmail -and $gitName -and -not $Force) {
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
                        -Application "WindowsSetup"
                }
                
                return $true
            }
        }
        
        $credentialTypes = @(
            @{
                Purpose  = "git"
                Prompt   = "Git configuration"
                Required = $true
                Fields   = @("Email", "Name")
            }
            # Add more credential types as needed
        )
        
        foreach ($credType in $credentialTypes) {
            $storedCred = Get-StoredCredential -Purpose $credType.Purpose
            
            if ($Force -or -not $storedCred) {
                Write-ColorOutput "Configuring credentials for: $($credType.Prompt)" "Status"
                
                $credentials = @{}
                foreach ($field in $credType.Fields) {
                    $value = Read-Host "Enter $field"
                    if ($credType.Required -and [string]::IsNullOrWhiteSpace($value)) {
                        Write-ColorOutput "$field is required for $($credType.Prompt)" "Error"
                        return $false
                    }
                    $credentials[$field] = $value
                }
                
                # Create PSCredential object with additional properties
                $securePassword = ConvertTo-SecureString "placeholder" -AsPlainText -Force
                $credential = New-Object PSCredential($credentials["Name"], $securePassword)
                
                # Add additional fields as properties
                foreach ($field in $credType.Fields) {
                    if ($field -ne "Name") {
                        $credential | Add-Member -NotePropertyName $field -NotePropertyValue $credentials[$field]
                    }
                }
                
                # Store credentials
                Protect-InstallationCredentials -Credential $credential `
                    -Purpose $credType.Purpose `
                    -Application "WindowsSetup"
            }
        }
        
        return $true
    }
    catch {
        Write-Log "Failed to initialize development credentials: $_" -Level "ERROR"
        return $false
    }
}