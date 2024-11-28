function Initialize-ModuleHelpers {
    $helperFolders = @(
        'Directory',
        'Logging',
        'Transaction',
        'Utils'
    )

    foreach ($folder in $helperFolders) {
        $folderPath = Join-Path $HELPERS_ROOT $folder
        if (Test-Path $folderPath) {
            Get-ChildItem -Path $folderPath -Filter "*.ps1" | 
            ForEach-Object {
                . $_.FullName
            }
        }
    }
}