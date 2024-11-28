
function Invoke-SafeCommand {
    param(
        [Parameter(Mandatory = $true)]
        [scriptblock]$ScriptBlock,
        [string]$ErrorMessage,
        [int]$RetryCount = 3,
        [int]$RetryDelaySeconds = 5,
        [switch]$ContinueOnError
    )

    $attempt = 1
    do {
        try {
            $result = & $ScriptBlock
            if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) {
                throw "Command exited with code ${LASTEXITCODE}"
            }
            return $result
        }
        catch {
            Write-Log "Attempt $attempt failed: $_" -Level "WARN"
            if ($attempt -ge $RetryCount) {
                $fullError = "${ErrorMessage}: $_"
                Write-Log -Message $fullError -Level "ERROR"
                if (-not $ContinueOnError) {
                    throw $_
                }
                return $false
            }
            Start-Sleep -Seconds $RetryDelaySeconds
            $attempt++
        }
    } while ($true)
}