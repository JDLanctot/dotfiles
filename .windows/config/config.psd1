@{
    Paths                = @{
        'nvim'       = @{
            'source' = 'config\nvim'
            'target' = 'nvim'
            'type'   = 'directory'
        }
        'bat'        = @{
            'source' = 'config\bat\config'
            'target' = 'bat\config'
            'type'   = 'file'
        }
        'julia'      = @{
            'source' = '.julia\config\startup.jl'
            'target' = '.julia\config\startup.jl'
            'type'   = 'file'
        }
        'powershell' = @{
            'source' = '.windows\profile.ps1'
            'target' = 'profile.ps1'
            'type'   = 'file'
        }
        'starship'   = @{
            'source' = '.config\starship.toml'
            'target' = '.starship\starship.toml'
            'type'   = 'file'
        }
    }

    Programs             = @(
        @{Name = "git"; Alias = "git"; Required = $true }
        @{Name = "powershell-core"; Alias = "pwsh"; Required = $true }
        @{Name = "starship"; Alias = "starship"; Required = $true }
        @{Name = "zig"; Alias = "zig"; Required = $true }
        @{Name = "julia"; Alias = "julia"; Required = $false }
    )

    CliTools             = @(
        @{
            Name        = "zoxide"
            Required    = $true
            ConfigCheck = "zoxide init"
            ConfigText  = @"
# Zoxide Configuration
Invoke-Expression (& {
    `$hook = if (`$PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook `$hook powershell | Out-String)
})
"@
        }
        @{
            Name        = "fzf"
            Required    = $true
            ConfigCheck = "PSFzf"
            ConfigText  = @"
# PSFzf Configuration
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
"@
        }
        @{
            Name        = "ag"
            Required    = $false
            ConfigCheck = $null
            ConfigText  = $null
        }
        @{
            Name        = "bat"
            Required    = $false
            ConfigCheck = $null
            ConfigText  = $null
        }
        @{
            Name        = "ripgrep"
            Required    = $true
            ConfigCheck = $null
            ConfigText  = $null
        }
        @{
            Name        = "7zip"
            Required    = $true
            ConfigCheck = $null
            ConfigText  = $null
        }
        @{
            Name        = "unzip"
            Required    = $true
            ConfigCheck = $null
            ConfigText  = $null
        }
        @{
            Name        = "gzip"
            Required    = $true
            ConfigCheck = $null
            ConfigText  = $null
        }
        @{
            Name        = "wget"
            Required    = $true
            ConfigCheck = $null
            ConfigText  = $null
        }
        @{
            Name        = "fd"
            Required    = $true
            ConfigCheck = $null
            ConfigText  = $null
        }
        @{
            Name        = "neovim"
            Required    = $true
            ConfigCheck = "Set-Alias.*vim.*nvim"
            ConfigText  = @"
# Neovim alias
Set-Alias vim nvim
"@
        }
        @{
            Name        = "miniconda3"
            Required    = $true
            Alias       = "conda"
            ConfigCheck = "conda initialize"
            ConfigText  = $null
        }
    )

    InstallationProfiles = @{
        Minimal  = @{
            Steps = @(
                @{ Name = "Chocolatey"; Function = "Install-Chocolatey"; Required = $true }
                @{ Name = "Basic Programs"; Function = "Install-BasicPrograms"; Required = $true }
                @{ Name = "Credentials"; Function = "Initialize-DevelopmentCredentials"; Required = $true }
                @{ Name = "Git and SSH"; Function = "Install-GitSSH"; Required = $true }
                @{ Name = "PowerShell Profile"; Function = "Install-PowerShellProfile"; Required = $true }
            )
        }
        Standard = @{
            Steps = @(
                @{ Name = "Chocolatey"; Function = "Install-Chocolatey"; Required = $true }
                @{ Name = "Basic Programs"; Function = "Install-BasicPrograms"; Required = $true }
                @{ Name = "Credentials"; Function = "Initialize-DevelopmentCredentials"; Required = $true }
                @{ Name = "Git and SSH"; Function = "Install-GitSSH"; Required = $true }
                @{ Name = "Dotfiles"; Function = "Initialize-Dotfiles"; Required = $true }
                @{ Name = "CLI Tools"; Function = "Install-CliTools"; Required = $false }
                @{ Name = "Nerd Fonts"; Function = "Install-NerdFonts"; Required = $false }
                @{ Name = "Starship"; Function = "Install-Starship"; Required = $true }
                @{ Name = "PowerShell Profile"; Function = "Install-PowerShellProfile"; Required = $true }
                @{ Name = "Neovim"; Function = "Install-Neovim"; Required = $false }
                @{ Name = "Node.js and pnpm"; Function = "Install-Node"; Required = $false }
                @{ Name = "Julia"; Function = "Install-Julia"; Required = $false }
                @{ Name = "Zig"; Function = "Install-Zig"; Required = $false }
                @{ Name = "Miniconda"; Function = "Install-Miniconda"; Required = $false }
            )
        }
        Full     = @{
            Steps           = @(
                @{ Name = "Chocolatey"; Function = "Install-Chocolatey"; Required = $true }
                @{ Name = "Basic Programs"; Function = "Install-BasicPrograms"; Required = $true }
                @{ Name = "Credentials"; Function = "Initialize-DevelopmentCredentials"; Required = $true }
                @{ Name = "Git and SSH"; Function = "Install-GitSSH"; Required = $true }
                @{ Name = "Dotfiles"; Function = "Initialize-Dotfiles"; Required = $true }
                @{ Name = "CLI Tools"; Function = "Install-CliTools"; Required = $true }
                @{ Name = "Nerd Fonts"; Function = "Install-NerdFonts"; Required = $true }
                @{ Name = "Starship"; Function = "Install-Starship"; Required = $true }
                @{ Name = "PowerShell Profile"; Function = "Install-PowerShellProfile"; Required = $true }
                @{ Name = "Neovim"; Function = "Install-Neovim"; Required = $true }
                @{ Name = "Node.js and pnpm"; Function = "Install-Node"; Required = $true }
                @{ Name = "Julia"; Function = "Install-Julia"; Required = $true }
                @{ Name = "Zig"; Function = "Install-Zig"; Required = $true }
                @{ Name = "Miniconda"; Function = "Install-Miniconda"; Required = $true }
            )
            InheritFrom     = "Standard"
            MakeAllRequired = $true
        }
    }

    MinimumRequirements  = @{
        'PSVersion'           = '5.1'
        'WindowsVersion'      = '10.0'
        'RequiredDiskSpaceGB' = 10
    }

    VerifyConfigs        = @(
        @{
            Name    = "Starship initialization"
            Pattern = "Invoke-Expression \(&starship init powershell\)"
        }
        @{
            Name    = "PSFzf import"
            Pattern = "Import-Module PSFzf"
        }
        @{
            Name    = "Neovim alias"
            Pattern = "Set-Alias.*vim.*nvim"
        }
    )

    Dependencies         = @{
        'neovim'   = @('node', 'git', 'ripgrep', 'unzip', 'gzip', 'wget', 'fd', 'zig')
        'starship' = @()
        'node'     = @()
    }
}