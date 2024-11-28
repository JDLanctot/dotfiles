function Test-RequiredPrograms {
    $missing = @()
    foreach ($program in $Config.Programs.Where({ $_.Required })) {
        if (-not (Get-Command -Name $program.Alias -ErrorAction SilentlyContinue)) {
            $missing += $program.Name
        }
    }

    return $missing
}

# Function to check if a command exists
function Test-Command {
    param($Command)
    return [bool](Get-Command -Name $Command -ErrorAction SilentlyContinue)
}

function Test-SystemRequirements {
    Write-Log "Checking system requirements..." -Level "INFO"

    $checks = @(
        @{
            Name  = "PowerShell Version"
            Check = {
                $currentVersion = $PSVersionTable.PSVersion
                $requiredVersion = [Version]$Config.MinimumRequirements.PSVersion
                Write-Log "Current PowerShell version: $($currentVersion.ToString())" -Level "INFO"
                Write-Log "LASTEXITCODE before version check: $LASTEXITCODE" -Level "DEBUG"
                if ($currentVersion -lt $requiredVersion) {
                    throw "PowerShell version $currentVersion is below minimum required version $requiredVersion"
                }
                Write-Log "LASTEXITCODE after version comparison: $LASTEXITCODE" -Level "DEBUG"
                return $true
            }
        }
        @{
            Name  = "Windows Version"
            Check = {
                $osVersion = [System.Environment]::OSVersion.Version
                $requiredVersion = [Version]$Config.MinimumRequirements.WindowsVersion
                Write-Log "Current Windows version: $($osVersion.ToString())" -Level "INFO"

                if ($osVersion -lt $requiredVersion) {
                    throw "Windows version $osVersion is below minimum required version $requiredVersion"
                }
                return $true
            }
        }
        @{
            Name  = "Available Disk Space"
            Check = {
                $systemDrive = $env:SystemDrive[0]
                $freeSpace = (Get-PSDrive $systemDrive).Free / 1GB
                Write-Log "Available disk space: ${freeSpace}GB" -Level "INFO"

                if ($freeSpace -lt $Config.MinimumRequirements.RequiredDiskSpaceGB) {
                    throw "Insufficient disk space. Required: $($Config.MinimumRequirements.RequiredDiskSpaceGB)GB, Available: ${freeSpace}GB"
                }
                return $true
            }
        }
        @{
            Name  = "Administrator Privileges"
            Check = {
                $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
                Write-Log "Running with administrator privileges: $isAdmin" -Level "INFO"

                if (-not $isAdmin) {
                    throw "Script must be run with administrator privileges"
                }
                return $true
            }
        }
        @{
            Name  = "Internet Connectivity"
            Check = {
                $testConnection = Test-NetConnection -ComputerName "github.com" -Port 443 -WarningAction SilentlyContinue
                Write-Log "Internet connectivity to GitHub: $($testConnection.TcpTestSucceeded)" -Level "INFO"

                if (-not $testConnection.TcpTestSucceeded) {
                    throw "No internet connection or GitHub is unreachable"
                }
                return $true
            }
        }
        @{
            Name  = "TLS 1.2 Support"
            Check = {
                $currentProtocol = [System.Net.ServicePointManager]::SecurityProtocol
                Write-Log "Current security protocol: $currentProtocol" -Level "INFO"

                if (-not ($currentProtocol -band [System.Net.SecurityProtocolType]::Tls12)) {
                    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12
                    Write-Log "Enabled TLS 1.2 support" -Level "INFO"
                }
                return $true
            }
        }
        @{
            Name  = "PowerShell Script Execution Policy"
            Check = {
                $executionPolicy = Get-ExecutionPolicy
                Write-Log "Current execution policy: $executionPolicy" -Level "INFO"

                if ($executionPolicy -eq "Restricted") {
                    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
                    Write-Log "Set execution policy to Bypass for current process" -Level "INFO"
                }
                return $true
            }
        }
    )

    $allPassed = $true
    foreach ($check in $checks) {
        Write-Log "Running check: $($check.Name)" -Level "INFO"
        try {
            $result = Invoke-SafeCommand -ScriptBlock $check.Check -ErrorMessage "Failed $($check.Name) check"
            Write-Log "Check result: $result" -Level "DEBUG"
            if ($result) {
                Write-Log "$($check.Name) check passed" -Level "SUCCESS"
            }
            else {
                $allPassed = $false
                Write-Log "$($check.Name) check failed" -Level "ERROR"
            }
        }
        catch {
            $allPassed = $false
            Write-Log "$($check.Name) check failed: $_" -Level "ERROR"
            if ($check.Name -in @("Administrator Privileges", "PowerShell Version", "Windows Version")) {
                Write-Log "This is a critical requirement. Installation cannot continue." -Level "ERROR"
                return $false
            }
        }
    }

    if ($allPassed) {
        Write-Log "All system requirement checks passed" -Level "SUCCESS"
    }
    else {
        Write-Log "Some system requirements checks failed" -Level "WARN"
    }

    return $allPassed
}