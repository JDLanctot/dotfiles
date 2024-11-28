function Confirm-Installation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Component,
        [Parameter(Mandatory = $true)]
        [string]$VerificationScript
    )
    
    try {
        # Create verification script block
        $verificationBlock = [ScriptBlock]::Create($VerificationScript)
        
        # Execute verification
        $result = & $verificationBlock
        
        # Log result
        if ($result) {
            Write-Log "Verification passed for $Component" -Level "SUCCESS"
        }
        else {
            Write-Log "Verification failed for $Component" -Level "WARN"
        }
        
        return $result
    }
    catch {
        Write-Log "Verification failed for $(Component): $_" -Level "ERROR"
        return $false
    }
}