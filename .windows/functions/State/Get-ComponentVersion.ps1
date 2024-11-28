function Get-ComponentVersion {
    param([string]$Component)
    
    try {
        $versionCommand = switch ($Component) {
            'git' { 'git --version' }
            'neovim' { 'nvim --version' }
            'node' { 'node --version' }
            'starship' { 'starship --version' }
            default { return $null }
        }
        
        $version = Invoke-Expression $versionCommand
        return $version
    }
    catch {
        return $null
    }
}