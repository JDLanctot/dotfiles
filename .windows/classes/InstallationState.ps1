class InstallationState {
    [hashtable]$Steps
    [hashtable]$BackupPaths
    [datetime]$StartTime
    [string]$SessionId
    
    InstallationState() {
        $this.Steps = @{}
        $this.BackupPaths = @{}
        $this.StartTime = Get-Date
        $this.SessionId = [guid]::NewGuid().ToString()
    }
}