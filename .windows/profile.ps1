Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })

Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PsFzfOption -EnableFuzzySort

function .. { Set-Location .. }
function ... { Set-Location ../.. }
function .... { Set-Location ../../.. }
function fzn {nvim $(fzf --preview="bat --color=always {}")}

$env:FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -l -g ""'
