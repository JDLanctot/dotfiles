function Handle-Error {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.ErrorRecord]$ErrorRecord,
        [string]$ComponentName = "Unknown",
        [string]$Operation = "Unknown",
        [switch]$Critical,
        [switch]$Continue
    )
    
    try {
        # Build detailed error message
        $errorDetails = @{
            Component  = $ComponentName
            Operation  = $Operation
            Message    = $ErrorRecord.Exception.Message
            Category   = $ErrorRecord.CategoryInfo.Category
            StackTrace = $ErrorRecord.ScriptStackTrace
            LineNumber = $ErrorRecord.InvocationInfo.ScriptLineNumber
            Command    = $ErrorRecord.InvocationInfo.MyCommand
            Timestamp  = Get-Date
        }

        # Log structured error
        Write-StructuredLog -Message "Error in $Operation" `
            -Level "ERROR" `
            -Component $ComponentName `
            -Data $errorDetails

        # Handle critical errors
        if ($Critical) {
            Write-Log "CRITICAL ERROR: Operation cannot continue" -Level "ERROR"
            if (-not $Continue) {
                throw $ErrorRecord
            }
        }

        return $errorDetails
    }
    catch {
        # Fallback logging if structured logging fails
        Write-Log "Error processing error handler: $_" -Level "ERROR"
        throw
    }
}