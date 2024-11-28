class InstallationTransaction {
    [string]$Id
    [datetime]$StartTime
    [string]$StepName
    [hashtable]$Changes
    [hashtable]$Backups
    [string]$Status
    
    InstallationTransaction([string]$stepName) {
        $this.Id = [guid]::NewGuid().ToString()
        $this.StartTime = Get-Date
        $this.StepName = $stepName
        $this.Changes = @{
            Files       = @()
            Registry    = @()
            Environment = @()
            Services    = @()
        }
        $this.Backups = @{}
        $this.Status = "Started"
    }
}