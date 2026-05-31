<#
.SYNOPSIS
    Last boot time and current uptime.
.DESCRIPTION
    Shows how long the system has been running. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-LastBootAndUptime.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/powershell/module/cimcmdlets/get-ciminstance
    Tier: [TIER 1 - PRODUCTION READY]
#>
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Write-Log "Running Get-LastBootAndUptime.ps1 on $env:COMPUTERNAME"
    $result = $b=(Get-CimInstance Win32_OperatingSystem).LastBootUpTime; [pscustomobject]@{LastBoot=$b;UptimeDays=[math]::Round(((Get-Date)-$b).TotalDays,2)}
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
# Source: Verified from learn.microsoft.com/powershell/module/cimcmdlets/get-ciminstance
