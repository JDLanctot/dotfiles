@{
    RootModule         = 'WindowsSetup.psm1'
    ModuleVersion      = '1.0.0'
    GUID               = '31fc73d6-fc26-4670-b77a-4c7bcb60319c'
    Author             = 'Jordi Lanctot'
    Description        = 'Windows Development Environment Setup'
    PowerShellVersion  = '7.0'
    
    # Prevent .psd1 files from being opened in notepad
    FileList           = @(
        'config\config.psd1'
    )
    
    PrivateData        = @{
        PSData = @{
            Tags       = @('windows', 'setup', 'development')
            ProjectUri = 'https://github.com/jdlanctot/dotfiles'
        }
    }
    
    # Specify functions to export
    FunctionsToExport  = @(
        'Start-Installation',
        'Install-BasicPrograms',
        'Install-CliTools',
        'Install-GitSSH',
        'Install-Neovim',
        'Install-Node',
        'Install-PowerShellProfile',
        'Show-Summary',
        'Test-SystemRequirements'
    )
    
    # Specify required modules
    RequiredModules    = @()
    
    # Specify file types that should be treated as data
    TypesToProcess     = @()
    FormatsToProcess   = @()
    
    # Specify configuration files
    RequiredAssemblies = @()
    ScriptsToProcess   = @()
}