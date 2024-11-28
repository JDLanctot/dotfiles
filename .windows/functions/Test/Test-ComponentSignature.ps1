function Test-ComponentSignature {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ComponentPath,
        [string]$ExpectedThumbprint,
        [switch]$RequireSignature
    )

    if (-not (Get-Variable -Name 'HELPERS_ROOT' -Scope Script -ErrorAction SilentlyContinue)) {
        throw "Module is not properly initialized. HELPERS_ROOT is not defined."
    }
    
    try {
        # Get authenticode signature
        $signature = Get-AuthenticodeSignature -FilePath $ComponentPath
        
        if (-not $signature.Status -eq 'Valid') {
            if ($RequireSignature) {
                throw "Invalid signature for component: $ComponentPath"
            }
            Write-Log "Component not signed: $ComponentPath" -Level "WARN"
            return $false
        }
        
        # Verify certificate chain
        $chain = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Chain
        $chain.Build($signature.SignerCertificate)
        
        foreach ($element in $chain.ChainElements) {
            if ($element.Certificate.Thumbprint -eq $ExpectedThumbprint) {
                return $true
            }
        }
        
        if ($ExpectedThumbprint) {
            throw "Component signature does not match expected thumbprint"
        }
        
        # If we get here, signature is valid but no specific thumbprint was required
        return $true
    }
    catch {
        Write-Log "Signature verification failed: $_" -Level "ERROR"
        if ($RequireSignature) {
            throw
        }
        return $false
    }
}