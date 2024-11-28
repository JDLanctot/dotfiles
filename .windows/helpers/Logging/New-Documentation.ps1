function New-Documentation {
    param(
        [string]$ScriptPath,
        [string]$OutputPath
    )
    
    $ast = [System.Management.Automation.Language.Parser]::ParseFile(
        $ScriptPath, [ref]$null, [ref]$null
    )
    
    # Get all functions
    $functions = $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)
    
    # Generate markdown documentation
    $documentation = @"
# Windows Development Environment Setup Documentation
Generated on $(Get-Date)

## Installation Types
- Minimal: Basic setup with essential tools
- Standard: Recommended setup for most developers
- Full: Complete development environment

## Components
"@
    
    # Document configuration
    $documentation += "`n### Configuration`n"
    foreach ($path in $Config.Paths.Keys) {
        $documentation += "- **$path**`n"
        $documentation += "  - Source: $($Config.Paths[$path].source)`n"
        $documentation += "  - Target: $($Config.Paths[$path].target)`n"
    }
    
    # Document programs
    $documentation += "`n### Required Programs`n"
    foreach ($program in $Config.Programs | Where-Object { $_.Required }) {
        $documentation += "- $($program.Name)`n"
    }
    
    # Document CLI tools
    $documentation += "`n### CLI Tools`n"
    foreach ($tool in $Config.CliTools) {
        $documentation += "- **$($tool.Name)**"
        if ($tool.Required) {
            $documentation += " (Required)"
        }
        $documentation += "`n"
    }
    
    # Document functions
    $documentation += "`n## Installation Functions`n"
    foreach ($function in $functions) {
        $help = Get-Help $function.Name -ErrorAction SilentlyContinue
        if ($help) {
            $documentation += "`n### $($function.Name)`n"
            if ($help.Synopsis) {
                $documentation += "$($help.Synopsis)`n"
            }
            if ($help.Parameters) {
                $documentation += "`nParameters:`n"
                foreach ($parameter in $help.Parameters.Parameter) {
                    $documentation += "- **$($parameter.Name)**: $($parameter.Description.Text)`n"
                }
            }
        }
    }
    
    # Add verification steps
    $documentation += "`n## Verification Steps`n"
    foreach ($verify in $Config.VerifyConfigs) {
        $documentation += "- $($verify.Name)`n"
    }
    
    # Save documentation
    Set-Content -Path $OutputPath -Value $documentation
    Write-StructuredLog -Message "Generated documentation at $OutputPath" `
        -Level "INFO" -Component "Documentation" `
        -Data @{ OutputPath = $OutputPath }
}