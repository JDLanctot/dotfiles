class ProgressUI {
    [int]$LastLine = 0
    [string]$LastPhase = ""
    [hashtable]$LastStatus = @{}
    
    [void] Clear() {
        if ($this.LastLine -gt 0) {
            $currentLine = [Console]::CursorTop
            [Console]::SetCursorPosition(0, $currentLine - $this.LastLine)
            for ($i = 0; $i -lt $this.LastLine; $i++) {
                Write-Host (" " * [Console]::WindowWidth)
            }
            [Console]::SetCursorPosition(0, $currentLine - $this.LastLine)
        }
    }

    [void] Show([string]$Phase, [int]$Current, [int]$Total, [hashtable]$ComponentStatus) {
        # Clear previous progress if it exists
        $this.Clear()
        
        # Calculate progress
        $percentComplete = [math]::Floor(($Current / $Total) * 100)
        $width = 50
        $completed = [math]::Floor(($width * $Current) / $Total)
        $progressBar = "[" + ("█" * $completed) + ("░" * ($width - $completed)) + "]"
        
        # Build status display
        $lines = @(
            "╔════════════════════════════════════════════════════════════════╗",
            "║ Installation Progress: $Phase",
            "║ $progressBar $percentComplete%",
            "║",
            "║ Status:"
        )
        
        foreach ($component in $ComponentStatus.Keys | Sort-Object) {
            $status = $ComponentStatus[$component]
            $lines += "║ • ${component}: ${status}"
        }
        
        $lines += "╚════════════════════════════════════════════════════════════════╝"
        
        # Store state
        $this.LastLine = $lines.Count
        $this.LastPhase = $Phase
        $this.LastStatus = $ComponentStatus.Clone()
        
        # Display
        $lines | ForEach-Object { Write-Host $_ }
    }
}