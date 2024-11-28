function Merge-InstallationSteps {
    param(
        [array]$BaseSteps,
        [array]$NewSteps
    )
    
    $mergedSteps = @()
    $stepNames = @{}
    
    # Add base steps first
    foreach ($step in $BaseSteps) {
        if (-not $stepNames.ContainsKey($step.Name)) {
            $mergedSteps += $step
            $stepNames[$step.Name] = $true
        }
    }
    
    # Override/add new steps
    foreach ($step in $NewSteps) {
        if ($stepNames.ContainsKey($step.Name)) {
            # Replace existing step
            $index = [array]::IndexOf($mergedSteps.Name, $step.Name)
            if ($index -ge 0) {
                $mergedSteps[$index] = $step
            }
        }
        else {
            # Add new step
            $mergedSteps += $step
            $stepNames[$step.Name] = $true
        }
    }
    
    return $mergedSteps
}
