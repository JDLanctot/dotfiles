function Install-ComponentsParallel {
    param(
        [Parameter(Mandatory = $true)]
        [array]$Components,
        [hashtable]$DependencyMap = @{},
        [switch]$SafetyCheck
    )
    
    # Group components by their dependencies
    $installationGroups = @{}
    $standalone = @()
    
    foreach ($component in $Components) {
        if ($DependencyMap.ContainsKey($component.Name)) {
            $deps = $DependencyMap[$component.Name]
            $level = ($deps | Measure-Object -Maximum).Maximum + 1
            if (-not $installationGroups[$level]) {
                $installationGroups[$level] = @()
            }
            $installationGroups[$level] += $component
        }
        else {
            $standalone += $component
        }
    }
    
    # Safety check for parallel installation
    if ($SafetyCheck) {
        $conflicts = @()
        foreach ($component in $Components) {
            if (Test-PathInUse -Path (Get-ComponentPath $component.Name)) {
                $conflicts += $component.Name
            }
        }
        
        if ($conflicts) {
            throw "Components cannot be installed in parallel due to path conflicts: $($conflicts -join ', ')"
        }
    }
    
    # Install components by dependency level
    $results = @{
        Successful = @()
        Failed     = @()
    }
    
    # First install standalone components in parallel
    $jobs = @()
    foreach ($component in $standalone) {
        $jobs += Start-Job -ScriptBlock {
            param($comp)
            Install-Component -Name $comp.Name
        } -ArgumentList $component
    }
    
    Wait-Job $jobs | Receive-Job
    Remove-Job $jobs
    
    # Then install grouped components by level
    foreach ($level in ($installationGroups.Keys | Sort-Object)) {
        $groupJobs = @()
        foreach ($component in $installationGroups[$level]) {
            # Check if dependencies are met
            $depsInstalled = $true
            foreach ($dep in $DependencyMap[$component.Name]) {
                if ($dep -notin $results.Successful) {
                    $depsInstalled = $false
                    break
                }
            }
            
            if ($depsInstalled) {
                $groupJobs += Start-Job -ScriptBlock {
                    param($comp)
                    Install-Component -Name $comp.Name
                } -ArgumentList $component
            }
        }
        
        $results += Wait-Job $groupJobs | Receive-Job
        Remove-Job $groupJobs
    }
    
    return $results
}