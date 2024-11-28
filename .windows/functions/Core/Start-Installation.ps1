function Start-Installation {
    [CmdletBinding()]
    param(
        [ValidateSet('Minimal', 'Standard', 'Full')]
        [string]$InstallationType = 'Standard',
        [switch]$Force,
        [switch]$NoBackup,
        [switch]$Silent
    )
    
    try {
        # Initialize installation
        $initResult = Initialize-Installation -InstallationType $InstallationType -Force:$Force
        if (-not $initResult) {
            throw "Installation initialization failed"
        }

        Write-Log "Starting $InstallationType installation" -Level "INFO"

        # Verify configuration
        if (-not $script:Config -or -not $script:Config.InstallationProfiles) {
            throw "Invalid configuration state: Installation profiles not found"
        }

        # Get installation profile
        $profile = $script:Config.InstallationProfiles[$InstallationType]
        if (-not $profile) {
            throw "Installation profile not found: $InstallationType"
        }

        # Get steps
        $steps = $profile.Steps
        if (-not $steps -or $steps.Count -eq 0) {
            throw "No installation steps found for profile: $InstallationType"
        }

        Write-Log "Found $($steps.Count) steps for profile $InstallationType" -Level "INFO"

        # Show installation plan if not silent
        if (-not $Silent) {
            Show-InstallationPlan -Steps $steps -Type $InstallationType
        }

        $results = @{
            Total       = $steps.Count
            Successful  = 0
            Failed      = 0
            Skipped     = 0
            FailedSteps = @()
        }

        # Execute installation steps
        $stepNumber = 0
        foreach ($step in $steps) {
            $stepNumber++
            Write-Log "Executing step $stepNumber of $($steps.Count): $($step.Name)" -Level "INFO"

            try {
                if (-not $Silent) {
                    $response = Show-Checkpoint -Message "Installing $($step.Name)" -Confirm:(-not $Force)
                    if ($response -eq "Skip" -and -not $step.Required) {
                        $results.Skipped++
                        Write-Log "Skipped optional step: $($step.Name)" -Level "INFO"
                        continue
                    }
                }

                # Convert string function name to scriptblock if necessary
                $action = $step.Function
                if ($action -is [string]) {
                    $action = [ScriptBlock]::Create($action)
                }

                # Execute step
                $success = & $action
                
                if ($success) {
                    $results.Successful++
                    Write-Log "Step completed successfully: $($step.Name)" -Level "SUCCESS"
                }
                else {
                    throw "Step returned false"
                }
            }
            catch {
                $results.Failed++
                $results.FailedSteps += $step.Name
                
                $errorDetails = Handle-Error -ErrorRecord $_ `
                    -ComponentName $step.Name `
                    -Operation "Installation" `
                    -Critical:$step.Required `
                    -Continue:(-not $step.Required)

                if ($step.Required -and -not $Force) {
                    throw "Required step '$($step.Name)' failed: $($errorDetails.Message)"
                }
            }
        }

        # Show summary
        Show-Summary -Results $results

        if ($results.Failed -eq 0) {
            Write-Log "Installation completed successfully" -Level "SUCCESS"
        }
        else {
            Write-Log "Installation completed with $($results.Failed) failed steps" -Level "WARN"
        }

        return $results
    }
    catch {
        Handle-Error -ErrorRecord $_ `
            -ComponentName "Installation" `
            -Operation "Start-Installation" `
            -Critical
        return $false
    }
}