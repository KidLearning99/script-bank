<#
.SYNOPSIS
    System & Application errors in last 24h.
.DESCRIPTION
    Pulls error/critical events from the last day for triage. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-RecentSystemErrors.ps1 -Verbose
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
    Write-Log "Running Get-RecentSystemErrors.ps1 on $env:COMPUTERNAME"
    $result = $s=(Get-Date).AddHours(-24); 'System','Application' | ForEach-Object { Get-WinEvent -FilterHashtable @{LogName=$_;Level=1,2;StartTime=$s} -EA SilentlyContinue | Select-Object TimeCreated,LogName,Id,ProviderName }
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
# Source: Verified from learn.microsoft.com/powershell/module/microsoft.powershell.diagnostics/get-winevent
