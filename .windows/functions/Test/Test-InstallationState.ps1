function Test-InstallationState {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Component,
        [switch]$IncludePartialState
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

            "Git Environment" {
                if (-not (Get-Command -Name git -ErrorAction SilentlyContinue)) {
                    return $false
                }
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

            "Nerd Fonts" {
                $fontPath = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts\JetBrainsMono*.ttf"
                return (Test-Path $fontPath)
            }

            "Alacritty" {
                # First check if command exists in PATH
                if (-not (Get-Command -Name alacritty -ErrorAction SilentlyContinue)) {
                    # If not in PATH, check MSI installation paths
                    $msiPath = @(
                        "${env:ProgramFiles}\Alacritty\alacritty.exe",
                        "${env:LocalAppData}\Programs\Alacritty\alacritty.exe"
                    )
                    $installed = $false
                    foreach ($path in $msiPath) {
                        if (Test-Path $path) {
                            $installed = $true
                            break
                        }
                    }
                    if (-not $installed) {
                        return $false
                    }
                }
                
                # Only verify directory exists, since files come later
                $configDir = "$env:USERPROFILE\AppData\Roaming\alacritty"
                return (Test-Path $configDir)
            }

            "GlazeWM" {
                if (-not (Get-Command -Name glazewm -ErrorAction SilentlyContinue)) {
                    # Check common installation paths for winget
                    $glazePaths = @(
                        "${env:ProgramFiles}\GlazeWM\glazewm.exe",
                        "${env:LocalAppData}\Programs\GlazeWM\glazewm.exe"
                    )
                    $installed = $false
                    foreach ($path in $glazePaths) {
                        if (Test-Path $path) {
                            $installed = $true
                            break
                        }
                    }
                    if (-not $installed) {
                        return $false
                    }
                }
                $configPath = "$env:USERPROFILE\.glzr\glazewm\config.yaml"
                return (Test-Path $configPath)
            }

            default {
                Write-Log "Missing verification logic for component: $Component" -Level "WARN"
                return $stateExists
            }
        }
    }
    catch {
        Write-Log "Failed to verify $ComponentName installation" -Level "ERROR"
        return $false
    }
}