function Get-ComponentPath {
    param([string]$Component)
    
    # Define known paths for components
    $componentPaths = @{
        'neovim'   = "$env:LOCALAPPDATA\nvim"
        'starship' = "$env:USERPROFILE\.starship"
        'git'      = "$env:ProgramFiles\Git"
    }
    
    if ($componentPaths.ContainsKey($Component)) {
        return $componentPaths[$Component]
    }
    
    # Try to find command path
    try {
        $command = Get-Command -Name $Component -ErrorAction SilentlyContinue
        if ($command) {
            return $command.Source
        }
    }
    catch {
        return $null
    }
    
    return $null
}