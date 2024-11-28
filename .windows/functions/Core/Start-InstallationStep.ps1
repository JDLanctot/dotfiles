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
        
        # Handle existing recovery point
        if ($initResult.RecoveryAvailable -and -not $Force) {
            $response = Show-Checkpoint -Message "Recovery Found" -Detail "Would you like to resume the previous installation?" -Confirm
            if ($response -eq "Continue") {
                $recoveryState = Resume-RecoveryPoint -RecoveryPoint $initResult.RecoveryPoint
                if ($recoveryState) {
                    $InstallationType = $recoveryState.InstallationType
                    Write-Log "Resumed from recovery point" -Level "SUCCESS"
                }
            }
        }

        Write-Log "Starting $InstallationType installation" -Level "INFO"

        # Get installation steps
        $steps = Get-InstallationSteps -Type $InstallationType
        if (-not $steps) {
            throw "No installation steps found for type: $InstallationType"
        }

        $results = @{
            Total       = $steps.Count
            Successful  = 0
            Failed      = 0
            Skipped     = 0
            FailedSteps = @()
        }

        # Show installation plan if not silent
        if (-not $Silent) {
            Show-InstallationPlan -Steps $steps -Type $InstallationType
        }

        # Execute installation steps
        $stepNumber = 0
        $componentStatus = @{}

        # Group steps by whether they can be run in parallel
        $parallelSteps = @()
        $serialSteps = @()
        
        foreach ($step in $steps) {
            if (-not $step.Required -and $step.Name -in @(
                    'CliTools', 'NerdFonts', 'Node', 'Julia', 'Zig', 'Miniconda'
                )) {
                $parallelSteps += $step
            }
            else {
                $serialSteps += $step
            }
        }

        # Process serial steps that must run first (required steps)
        foreach ($step in $serialSteps) {
            $stepNumber++
            
            # Show progress
            Show-InstallationProgress -Phase $step.Name -Current $stepNumber -Total $steps.Count -ComponentStatus $componentStatus
            
            try {
                if (-not $Silent) {
                    $response = Show-Checkpoint -Message "Installing $($step.Name)" -Confirm:(-not $Force)
                    if ($response -eq "Skip" -and -not $step.Required) {
                        $results.Skipped++
                        $componentStatus[$step.Name] = "Skipped"
                        continue
                    }
                }

                # Create recovery point
                Initialize-RecoveryPoint -StepName $step.Name -State @{
                    InstallationType = $InstallationType
                    CurrentStep      = $stepNumber
                    ComponentStatus  = $componentStatus
                }

                # Execute step
                $success = Start-InstallationStep -StepName $step.Name -Action $step.Function -NoBackup:$NoBackup

                if ($success) {
                    $results.Successful++
                    $componentStatus[$step.Name] = "Success"
                }
                else {
                    throw "Step failed"
                }

                # Verify installation if verification script exists
                $verificationScript = Get-VerificationScript -StepName $step.Name
                if ($success -and $verificationScript) {
                    if (-not (Confirm-Installation -Component $step.Name -VerificationScript $verificationScript)) {
                        Write-Log "Verification failed for $($step.Name)" -Level "WARN"
                        Show-Checkpoint -Message "Verification Warning" -Detail "Verification failed for $($step.Name)" -Warning
                    }
                }
            }
            catch {
                $results.Failed++
                $results.FailedSteps += $step.Name
                $componentStatus[$step.Name] = "Failed"

                if ($step.Required -and -not $Force) {
                    Write-Log "Required step $($step.Name) failed: $_" -Level "ERROR"
                    
                    # Attempt automatic recovery
                    if (-not $NoBackup) {
                        Write-Log "Attempting recovery..." -Level "INFO"
                        if (-not (Restore-Installation -StepName $step.Name)) {
                            throw "Recovery failed for required step: $($step.Name)"
                        }
                    }
                    
                    throw "Required step $($step.Name) failed: $_"
                }
                else {
                    Write-Log "Non-required step $($step.Name) failed: $_" -Level "WARN"
                }
            }
        }

        # Process parallel steps if any exist
        if ($parallelSteps.Count -gt 0) {
            Write-Log "Starting parallel installation of optional components..." -Level "INFO"
            
            # Create jobs for parallel installation
            $jobs = @()
            foreach ($step in $parallelSteps) {
                $stepNumber++
                Show-InstallationProgress -Phase $step.Name -Current $stepNumber -Total $steps.Count -ComponentStatus $componentStatus
                
                $jobs += Start-Job -ScriptBlock {
                    param($StepName, $Action, $NoBackup)
                    Start-InstallationStep -StepName $StepName -Action $Action -NoBackup:$NoBackup
                } -ArgumentList $step.Name, $step.Function, $NoBackup
            }

            # Wait for all jobs to complete
            $jobResults = $jobs | Wait-Job | Receive-Job
            
            # Process results from parallel installations
            for ($i = 0; $i -lt $parallelSteps.Count; $i++) {
                $step = $parallelSteps[$i]
                $success = $jobResults[$i]

                if ($success) {
                    $results.Successful++
                    $componentStatus[$step.Name] = "Success"
                    
                    # Verify installation if needed
                    $verificationScript = Get-VerificationScript -StepName $step.Name
                    if ($verificationScript) {
                        if (-not (Confirm-Installation -Component $step.Name -VerificationScript $verificationScript)) {
                            Write-Log "Verification failed for $($step.Name)" -Level "WARN"
                            Show-Checkpoint -Message "Verification Warning" -Detail "Verification failed for $($step.Name)" -Warning
                        }
                    }
                }
                else {
                    $results.Failed++
                    $results.FailedSteps += $step.Name
                    $componentStatus[$step.Name] = "Failed"
                    Write-Log "Parallel installation failed for $($step.Name)" -Level "WARN"
                }
            }

            # Clean up jobs
            $jobs | Remove-Job
        }

        # Show summary
        Show-Summary -Results $results

        # Cleanup successful installation
        if ($results.Failed -eq 0) {
            Clear-RecoveryPoints
            Write-Log "Installation completed successfully" -Level "SUCCESS"
        }

        return $results
    }
    catch {
        Write-StructuredLog -Message "Installation failed: $_" -Level "ERROR" -Component "Setup" -Data @{ Error = $_.ToString() }
        Show-Checkpoint -Message "Installation Failed" -Detail $_.Exception.Message -Warning
        throw
    }
}