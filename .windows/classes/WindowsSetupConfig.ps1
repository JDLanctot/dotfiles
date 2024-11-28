class WindowsSetupConfig {
    [hashtable]$Paths
    [array]$Programs
    [array]$CliTools
    [hashtable]$InstallationProfiles
    
    WindowsSetupConfig([string]$configPath) {
        $config = Import-PowerShellDataFile $configPath
        $this.Initialize($config)
    }
    
    [void]Initialize([hashtable]$config) {
        $this.Paths = $config.Paths
        $this.Programs = $config.Programs
        $this.CliTools = $config.CliTools
        $this.InstallationProfiles = $config.InstallationProfiles
    }
}
