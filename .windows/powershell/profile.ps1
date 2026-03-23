$env:EDITOR = "nvim"
$env:STARSHIP_CONFIG = "$HOME\.starship\starship.toml"
$env:STARSHIP_DISTRO = "者 "
Invoke-Expression (&'C:\Program Files\starship\bin\starship.exe' init powershell)

Invoke-Expression (& { (zoxide init powershell | Out-String) })

Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PsFzfOption -EnableFuzzySort

# Faster moving
function .. { Set-Location .. }

# Improved FzF
function fzn {nvim $(fzf --preview="bat --color=always {}")}
function fzc {code $(fzf --preview="bat --color=always {}")}

# Conda
function ca {
    param([string]$envName)
    conda activate $envName
}
function caz {
    param([string]$envName)
    z $envName
    conda activate $envName
}

# uv + Ruff
function ua {
    .venv\Scripts\Activate.ps1
}
function uaz {
    param([string]$envName)
    z $envName
    .venv\Scripts\Activate.ps1
}
function uvs { uv sync @args }
function uvr { uv run @args }
function uvt { uv run pytest @args }
function rufffix {
    uv run ruff check . --fix
    if ($LASTEXITCODE -eq 0) {
        uv run ruff format .
    }
}

# Enhanced Listing
function ll {eza -ll}
function la {eza -la}

# Git Shortcuts
function gs { git status }
function ga { git add . }
function gc { param($m) git commit -m "$m" }
function gp { git push }
function g { __zoxide_z github }
function gcl { git clone "$args" }
function gcom {
    git add .
    git commit -m "$args"
}

# Quick Access to System Information
function sysinfo { Get-ComputerInfo }

# Clipboard Utilities
function cpy { Set-Clipboard $args[0] }
function pst { Get-Clipboard }

# Neofetch
function ff { fastfetch }

# Clear corrupted SHADA Files
function cltmp {
    param(
        [string]$Path = (Join-Path $env:LOCALAPPDATA 'nvim-data\shada')
    )

    # Get all files that match the pattern 'main.shada.tmp.*'
    $files = Get-ChildItem -Path $Path -Filter "main.shada.tmp.*" -File -ErrorAction SilentlyContinue

    # Remove all matching files if found
    if ($files) {
        Remove-Item -Path $files.FullName -Force
    }
}

$env:FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -l -g ""'

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

