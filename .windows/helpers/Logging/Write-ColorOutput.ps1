function Write-ColorOutput {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,
        [Parameter(Mandatory = $true)]
        [string]$Type
    )

    $level = switch ($Type) {
        "Error" { "ERROR" }
        "Success" { "SUCCESS" }
        "Status" { "INFO" }
        default { "INFO" }
    }

    Write-Log -Message $Message -Level $level
}