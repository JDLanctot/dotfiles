function Write-ColorOutput {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,
        [Parameter(Mandatory = $true)]
        [string]$Type
    )

    # Skip if in silent mode and not an error/warning
    if ($script:Silent -and $Type -notin @("Error", "Warning")) {
        return
    }

    $level = switch ($Type) {
        "Error" { "ERROR" }
        "Success" { "SUCCESS" }
        "Status" { "INFO" }
        default { "INFO" }
    }

    Write-Log -Message $Message -Level $level
}