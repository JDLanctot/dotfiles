function Complete-InstallationTransaction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [InstallationTransaction]$Transaction,
        [switch]$Commit
    )
    
    try {
        if ($Commit) {
            # Verify all changes are valid
            foreach ($change in $Transaction.Changes.Files) {
                if (-not (Test-Path $change.Path)) {
                    throw "Expected file not found: $($change.Path)"
                }
            }
            
            # Update installation state
            $Transaction.Status = "Committed"
            Save-InstallationState -StepName $Transaction.StepName
            
            # Clean up backups after successful commit
            foreach ($backup in $Transaction.Backups.Values) {
                Remove-Item $backup.Path -Force -ErrorAction SilentlyContinue
            }
        }
        else {
            # Rollback changes
            foreach ($change in $Transaction.Changes.Files) {
                if (Test-Path $change.Path) {
                    Remove-Item $change.Path -Force -ErrorAction SilentlyContinue
                }
            }
            
            # Restore backups
            foreach ($backup in $Transaction.Backups.Values) {
                Copy-Item $backup.Path $backup.OriginalPath -Force
            }
            
            $Transaction.Status = "Rolled Back"
        }
    }
    catch {
        Write-Log "Transaction operation failed: $_" -Level "ERROR"
        throw
    }
    finally {
        # Clean up watchers and handlers
        Get-EventSubscriber | Where-Object { 
            $_.SourceObject.Path -eq $env:ProgramFiles 
        } | Unregister-Event
    }
}