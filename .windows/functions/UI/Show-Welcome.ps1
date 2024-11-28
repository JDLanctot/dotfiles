function Show-Welcome {
    $welcome = @"
╔════════════════════════════════════════════════════════════════════════════════╗
║                      Windows Development Environment Setup                      ║
╚════════════════════════════════════════════════════════════════════════════════╝

This script will set up your Windows development environment. There are three installation types:

1. Minimal - Basic setup with essential tools
   • PowerShell Profile
   • Basic utilities
   • Core configurations

2. Standard - Recommended setup for most developers
   • Everything in Minimal
   • Git + SSH
   • Development tools (Neovim, Node.js, etc.)
   • CLI utilities
   • Optional components can be skipped

3. Full - Complete development environment
   • Everything in Standard
   • All optional components become required
   • Additional development tools
   • Complete CLI toolkit

"@
    Write-Host $welcome -ForegroundColor Cyan

    if (-not $Silent) {
        $choice = Read-Host "Select installation type (1-Minimal, 2-Standard, 3-Full) [2]"
        
        switch ($choice) {
            "1" { return "Minimal" }
            "3" { return "Full" }
            default { return "Standard" }
        }
    }
    return $InstallationType
}