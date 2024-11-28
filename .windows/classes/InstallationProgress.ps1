class InstallationProgress {
    [string]$CurrentPhase
    [int]$TotalSteps
    [int]$CurrentStep
    [hashtable]$ComponentStatus
    [datetime]$StartTime
    [timespan]$EstimatedTimeRemaining
    
    InstallationProgress([int]$totalSteps) {
        $this.TotalSteps = $totalSteps
        $this.CurrentStep = 0
        $this.StartTime = Get-Date
        $this.ComponentStatus = @{}
    }
    
    [void]Update([string]$phase, [int]$step) {
        $this.CurrentPhase = $phase
        $this.CurrentStep = $step
        $this.UpdateEstimatedTime()
    }
    
    [void]UpdateEstimatedTime() {
        $elapsed = (Get-Date) - $this.StartTime
        $percentComplete = $this.CurrentStep / $this.TotalSteps
        if ($percentComplete -gt 0) {
            $totalEstimate = $elapsed.TotalSeconds / $percentComplete
            $this.EstimatedTimeRemaining = [timespan]::FromSeconds($totalEstimate - $elapsed.TotalSeconds)
        }
    }
}