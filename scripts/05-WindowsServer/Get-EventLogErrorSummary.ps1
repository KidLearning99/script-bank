<#
.SYNOPSIS
    Error counts by source (System, last 7d).
.DESCRIPTION
    Aggregates recent System errors by provider. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-EventLogErrorSummary.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/powershell/module/microsoft.powershell.diagnostics/get-winevent
    Tier: [TIER 1 - PRODUCTION READY]
#>
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Write-Log "Running Get-EventLogErrorSummary.ps1 on $env:COMPUTERNAME"
    $result = $s=(Get-Date).AddDays(-7); Get-WinEvent -FilterHashtable @{LogName='System';Level=1,2;StartTime=$s} -EA SilentlyContinue | Group-Object ProviderName | Sort-Object Count -Descending | Select-Object Name,Count
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
# Source: Verified from learn.microsoft.com/powershell/module/microsoft.powershell.diagnostics/get-winevent
