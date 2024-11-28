function Test-Command {
    if (-not (Get-Variable -Name 'HELPERS_ROOT' -Scope Script -ErrorAction SilentlyContinue)) {
        throw "Module is not properly initialized. HELPERS_ROOT is not defined."
    }
    
    param($Command)
    return [bool](Get-Command -Name $Command -ErrorAction SilentlyContinue)
}