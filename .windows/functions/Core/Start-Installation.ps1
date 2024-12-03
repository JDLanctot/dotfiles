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
        $script:Silent = $Silent

        
        if (-not $Silent) {
            Write-Host "`n" # Add initial spacing
        }
        
        # Initialize installation state
        $initResult = Initialize-Installation -InstallationType $InstallationType -Force:$Force
        
        # Use the config from the initialization result
        $configToUse = if ($script:Config) { $script:Config } else { $initResult.Config }
        
        if (-not $configToUse) {
            throw "No configuration available"
        }
        
        # Get installation steps from config
        $steps = $configToUse.InstallationProfiles[$InstallationType].Steps
        Write-Log "Found $($steps.Count) steps for profile $InstallationType" -Level "INFO"
        
        # Initialize results tracking
        $results = @{
            Total      = $steps.Count
            Successful = [System.Collections.ArrayList]::new()
            Failed     = [System.Collections.ArrayList]::new()
            Skipped    = [System.Collections.ArrayList]::new()
        }

        # Track progress
        $currentStep = 0
        $totalSteps = $steps.Count
        $status = @{}

        foreach ($step in $steps) {
            $currentStep++
            $percentComplete = [math]::Floor(($currentStep / $totalSteps) * 100)        
            $progressBar = "["
            $progressBar += "█" * [math]::Floor($percentComplete / 2)
            $progressBar += "░" * (50 - [math]::Floor($percentComplete / 2))
            $progressBar += "]"

            if (-not $Silent) {
                Write-Progress -Activity $Phase -Status "$Current of $Total steps complete" -PercentComplete ($Current / $Total * 100)
            }

            try {
                # Check if already installed
                $isInstalled = Test-InstallationState $step.Name
                if ($isInstalled) {
                    Write-Log "$($step.Name) is already installed" -Level "INFO"
                    [void]$results.Skipped.Add($step.Name)
                    $status[$step.Name] = "Skipped"
                    continue
                }
        
                # Get the function to execute
                $function = $step.Function
                if ($function -is [ScriptBlock]) {
                    Write-Log "Executing script block for $($step.Name)" -Level "DEBUG"
                    $result = & $function
                }
                else {
                    # Try to get function by name
                    $functionName = $function.ToString().Trim('{}') # Remove braces if present
                    Write-Log "Looking for function: $functionName" -Level "DEBUG"
                    $functionToExecute = Get-Command $functionName -ErrorAction SilentlyContinue
                    if ($functionToExecute) {
                        $result = & $functionToExecute
                    }
                    else {
                        throw "Function not found: $functionName"
                    }
                }
        
                if ($null -eq $result) {
                    Write-Log "Warning: $($step.Name) returned no value, assuming success" -Level "WARN"
                    $result = $true
                }
        
                if ($result -eq $true) {
                    [void]$results.Successful.Add($step.Name)
                    $status[$step.Name] = "Success"
                    Write-Log "$($step.Name) installed successfully" -Level "SUCCESS"
                }
                elseif ($result -eq $false) {
                    [void]$results.Skipped.Add($step.Name)
                    $status[$step.Name] = "Skipped"
                    Write-Log "$($step.Name) was skipped" -Level "INFO"
                }
                else {
                    Write-Log "Unexpected return value from $($step.Name): $result" -Level "WARN"
                    # Determine status based on verification
                    if (Test-InstallationState $step.Name) {
                        [void]$results.Skipped.Add($step.Name)
                        $status[$step.Name] = "Skipped"
                    }
                    else {
                        [void]$results.Successful.Add($step.Name)
                        $status[$step.Name] = "Success"
                    }
                }
            }
            catch {
                [void]$results.Failed.Add($step.Name)
                $status[$step.Name] = "Failed"
                Write-Log "Failed to execute $($step.Name): $_" -Level "ERROR"
                
                if ($step.Required -and -not $Force) {
                    throw
                }
            }
        }

        # Show final summary
        Write-Host "`n╔════════════════════════════════════════════════════════════════╗"
        Write-Host "║                      Installation Summary                       ║"
        Write-Host "╠════════════════════════════════════════════════════════════════╣"
        Write-Host "║ Total Steps:    $($results.Total.ToString().PadRight(4)) ║"
        Write-Host "║ Successful:     $($results.Successful.Count.ToString().PadRight(4)) ║"
        Write-Host "║ Failed:         $($results.Failed.Count.ToString().PadRight(4)) ║"
        Write-Host "║ Skipped:        $($results.Skipped.Count.ToString().PadRight(4)) ║"
        Write-Host "╚════════════════════════════════════════════════════════════════╝"

        if ($results.Successful.Count -gt 0) {
            Write-Host "`nSuccessfully Completed:"
            foreach ($step in $results.Successful) {
                Write-Host "  • $step"
            }
        }
        
        if ($results.Skipped.Count -gt 0) {
            Write-Host "`nSkipped Steps:"
            foreach ($step in $results.Skipped) {
                Write-Host "  • $step"
            }
        }
        
        if ($results.Failed.Count -gt 0) {
            Write-Host "`nFailed Steps:" -ForegroundColor Red
            foreach ($step in $results.Failed) {
                Write-Host "  • $step" -ForegroundColor Red
            }
        }

        Write-Host "`nLog File: $script:SCRIPT_LOG_PATH"
        
        return $results
    }
    catch {
        Write-Log "Installation failed: $_" -Level "ERROR"
        throw
    }
}