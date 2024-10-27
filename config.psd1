@{
    Paths = @{
        'nvim' = @{
            'source' = 'config\nvim'
            'target' = 'nvim'
            'type' = 'directory'
        }
        'bat' = @{
            'source' = 'config\bat\config'
            'target' = 'bat\config'
            'type' = 'file'
        }
        'julia' = @{
            'source' = '.julia\config\startup.jl'
            'target' = '.julia\config\startup.jl'
            'type' = 'file'
        }
        'powershell' = @{
            'source' = '.windows\profile.ps1'
            'target' = 'profile.ps1'
            'type' = 'file'
        }
        'starship' = @{
            'source' = '.config\starship.toml'
            'target' = '.config\starship.toml'
            'type' = 'file'
        }
    }

    Programs = @(
        @{Name = "git"; Alias = "git"; Required = $true}
        @{Name = "powershell-core"; Alias = "pwsh"; Required = $true}
        @{Name = "starship"; Alias = "starship"; Required = $true}
        @{Name = "fzf"; Alias = "fzf"; Required = $false}
        @{Name = "ag"; Alias = "ag"; Required = $false}
        @{Name = "bat"; Alias = "bat"; Required = $false}
    )

    MinimumRequirements = @{
        'PSVersion' = '5.1'
        'WindowsVersion' = '10.0'
        'RequiredDiskSpaceGB' = 10
    }

    VerifyConfigs = @(
        @{
            Name = "Starship initialization"
            Pattern = "Invoke-Expression \(&starship init powershell\)"
        }
        @{
            Name = "PSFzf import"
            Pattern = "Import-Module PSFzf"
        }
        @{
            Name = "Neovim alias"
            Pattern = "Set-Alias.*vim.*nvim"
        }
    )
}