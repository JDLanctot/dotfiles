function Test-InstallationState {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Component
    )
    
    try {
        $stateFile = "$env:USERPROFILE\.dotfiles_installed"
        $stateExists = (Test-Path $stateFile) -and ((Get-Content $stateFile) -contains $Component)

        # Component-specific verification
        switch ($Component) {
            "Chocolatey" {
                if (-not (Get-Command -Name choco -ErrorAction SilentlyContinue)) {
                    return $false
                }
                return $true
            }

            "Basic Programs" {
                foreach ($program in $Config.Programs) {
                    if (-not (Get-Command -Name $program.Alias -ErrorAction SilentlyContinue)) {
                        Write-Log "Required program not installed: $($program.Name)" -Level "INFO"
                        return $false
                    }
                }
                return $true
            }

            "Credentials" {
                if (-not (Get-Command -Name git -ErrorAction SilentlyContinue)) {
                    return $false
                }
                $gitEmail = git config --global user.email
                $gitName = git config --global user.name
                return ($null -ne $gitEmail -and $null -ne $gitName)
            }

            "Git and SSH" {
                # Check Git config
                $gitEmail = git config --global user.email
                $gitName = git config --global user.name
                if (-not ($gitEmail -and $gitName)) {
                    return $false
                }
    
                # Check SSH
                $sshDir = "$env:USERPROFILE\.ssh"
                return (Test-Path $sshDir)
            }

            "Dotfiles" {
                # Check for essential dotfiles
                $paths = @(
                    "$env:USERPROFILE\.starship\starship.toml",
                    "$env:LOCALAPPDATA\nvim\init.lua",
                    "$PROFILE"
                )
                foreach ($path in $paths) {
                    if (-not (Test-Path $path)) {
                        Write-Log "Missing dotfile: $path" -Level "INFO"
                        return $false
                    }
                }
                return $true
            }

            "CLI Tools" {
                foreach ($tool in $Config.CliTools) {
                    if (-not (Get-Command -Name $tool.Name -ErrorAction SilentlyContinue)) {
                        Write-Log "Required CLI tool not installed: $($tool.Name)" -Level "INFO"
                        return $false
                    }

                    if ($tool.ConfigCheck -and (Test-Path $PROFILE)) {
                        if (-not (Select-String -Path $PROFILE -Pattern $tool.ConfigCheck -Quiet)) {
                            Write-Log "Missing configuration for $($tool.Name)" -Level "INFO"
                            return $false
                        }
                    }
                }
                return $true
            }

            "Neovim" {
                if (-not (Get-Command -Name nvim -ErrorAction SilentlyContinue)) {
                    return $false
                }
                $configPath = "$env:LOCALAPPDATA\nvim\init.lua"
                $pluginsInstalled = Test-Path "$env:LOCALAPPDATA\nvim\lazy-lock.json"
                return ((Test-Path $configPath) -and $pluginsInstalled)
            }

            "Node.js and pnpm" {
                return ((Get-Command -Name node -ErrorAction SilentlyContinue) -and 
                       (Get-Command -Name pnpm -ErrorAction SilentlyContinue))
            }

            "Julia" {
                if (-not (Get-Command -Name julia -ErrorAction SilentlyContinue)) {
                    return $false
                }
                Write-Log "Julia installation detected" -Level "DEBUG"
                $configPath = "$env:USERPROFILE\.julia\config\startup.jl"
                return (Test-Path $configPath)
            }

            "Zig" {
                if (-not (Get-Command -Name zig -ErrorAction SilentlyContinue)) {
                    return $false
                }
                $zigPath = "C:\ProgramData\chocolatey\bin\zig.exe"
                return (Test-Path $zigPath)
            }

            "Miniconda" {
                # Check both Anaconda and Miniconda paths
                $anacondaPath = "C:\ProgramData\anaconda3\Scripts\conda.exe"
                $minicondaPath = "$env:USERPROFILE\Miniconda3\Scripts\conda.exe"
    
                if (-not (Test-Path $anacondaPath) -and -not (Test-Path $minicondaPath)) {
                    Write-Log "Conda command not found" -Level "DEBUG"
                    return $false
                }
    
                # Check profile initialization
                if (-not (Test-Path $PROFILE) -or -not (Select-String -Path $PROFILE -Pattern "conda.*initialize" -Quiet)) {
                    Write-Log "Conda initialization not found in profile" -Level "DEBUG"
                    return $false
                }
    
                return $true
            }

            "Starship" {
                if (-not (Get-Command -Name starship -ErrorAction SilentlyContinue)) {
                    return $false
                }
                $configPath = "$env:USERPROFILE\.starship\starship.toml"
                return ((Test-Path $configPath) -and 
                       (Test-Path $PROFILE) -and 
                       (Select-String -Path $PROFILE -Pattern "starship init" -Quiet))
            }

            "PowerShell Profile" {
                if (-not (Test-Path $PROFILE)) {
                    return $false
                }
                # Check for essential configurations
                $requiredPatterns = @(
                    "Invoke-Expression \(&starship init powershell\)",
                    "Import-Module PSFzf",
                    "Set-Alias.*vim.*nvim"
                )
                foreach ($pattern in $requiredPatterns) {
                    if (-not (Select-String -Path $PROFILE -Pattern $pattern -Quiet)) {
                        Write-Log "Missing profile configuration: $pattern" -Level "DEBUG"
                        return $false
                    }
                }
                return $true
            }

            "Nerd Fonts" {
                $fontPath = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts\JetBrainsMono*.ttf"
                return (Test-Path $fontPath)
            }

            default {
                Write-Log "Missing verification logic for component: $Component" -Level "WARN"
                return $stateExists
            }
        }
    }
    catch {
        Write-Log "Error checking installation state for $(Component): $_" -Level "ERROR"
        return $false
    }
}