function Test-SystemState {
    if (-not (Get-Variable -Name 'HELPERS_ROOT' -Scope Script -ErrorAction SilentlyContinue)) {
        throw "Module is not properly initialized. HELPERS_ROOT is not defined."
    }
    
    $results = @{
        DateTime        = Get-Date
        Components      = @{}
        SystemHealth    = @{
            DiskSpace = $null
            Memory    = $null
            Services  = @{}
        }
        Recommendations = @()
    }
    
    try {
        # Check disk space
        $systemDrive = $env:SystemDrive[0]
        $disk = Get-PSDrive $systemDrive
        $freeSpaceGB = [math]::Round($disk.Free / 1GB, 2)
        $results.SystemHealth.DiskSpace = @{
            Drive       = $systemDrive
            FreeSpaceGB = $freeSpaceGB
            Status      = if ($freeSpaceGB -gt 10) { "Healthy" } else { "Warning" }
        }
        
        # Check memory
        $os = Get-CimInstance Win32_OperatingSystem
        $freeMemoryGB = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
        $results.SystemHealth.Memory = @{
            FreeGB = $freeMemoryGB
            Status = if ($freeMemoryGB -gt 2) { "Healthy" } else { "Warning" }
        }
        
        # Check essential services
        $essentialServices = @("Windows Update", "Windows Installer")
        foreach ($service in $essentialServices) {
            $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
            $results.SystemHealth.Services[$service] = @{
                Status    = $svc.Status
                StartType = $svc.StartType
            }
        }
        
        # Check installed components
        foreach ($component in $INSTALLED_COMPONENTS.Keys) {
            $results.Components[$component] = Test-InstallationHealth -Component $component
        }
        
        # Generate recommendations
        if ($results.SystemHealth.DiskSpace.Status -eq "Warning") {
            $results.Recommendations += "Low disk space on $($results.SystemHealth.DiskSpace.Drive): $($results.SystemHealth.DiskSpace.FreeSpaceGB)GB free"
        }
        
        if ($results.SystemHealth.Memory.Status -eq "Warning") {
            $results.Recommendations += "Low memory: $($results.SystemHealth.Memory.FreeGB)GB free"
        }
        
        foreach ($component in $results.Components.Keys) {
            if ($results.Components[$component].Status -ne "Healthy") {
                $results.Recommendations += $results.Components[$component].Recommendations
            }
        }
    }
    catch {
        Write-Log "Failed to check system state: $_" -Level "ERROR"
    }
    
    return $results
}