function Initialize-ModuleFunctions {
    $functionFolders = @(
        'Test',
        'Core',
        'Cache',
        'Security',
        'Network',
        'State',
        'Initialize',
        'Install',
        'UI'
    )
    
    foreach ($folder in $functionFolders) {
        $folderPath = Join-Path $script:FUNCTIONS_ROOT $folder
        if (Test-Path $folderPath) {
            Get-ChildItem -Path $folderPath -Filter "*.ps1" | 
            ForEach-Object { 
                . $_.FullName 
            }
        }
    }
}
