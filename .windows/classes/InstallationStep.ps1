class InstallationStep {
    [string]$Name
    [bool]$Required
    [ScriptBlock]$Action
    [ScriptBlock]$Verification
    
    InstallationStep([string]$name, [bool]$required, $action) {
        $this.Name = $name
        $this.Required = $required
        
        # Convert string to ScriptBlock if necessary
        if ($action -is [string]) {
            $this.Action = [ScriptBlock]::Create($action)
        }
        elseif ($action -is [ScriptBlock]) {
            $this.Action = $action
        }
        else {
            throw "Invalid action type. Expected String or ScriptBlock, got: $($action.GetType().Name)"
        }
    }
    
    [bool]Execute() {
        try {
            $result = & $this.Action
            if ($result -and $this.Verification) {
                $result = & $this.Verification
            }
            return $result
        }
        catch {
            Write-Log "Step $($this.Name) failed: $_" -Level "ERROR"
            return $false
        }
    }
}