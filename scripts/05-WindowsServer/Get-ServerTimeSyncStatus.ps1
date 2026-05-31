<#
.SYNOPSIS
    Windows Time service sync status.
.DESCRIPTION
    Reports time source and sync state (w32tm). Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-ServerTimeSyncStatus.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/windows-server/networking/windows-time-service/windows-time-service-tools-and-settings
    Tier: [TIER 1 - PRODUCTION READY]
#>
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Write-Log "Running Get-ServerTimeSyncStatus.ps1 on $env:COMPUTERNAME"
    $result = [pscustomobject]@{Status=(w32tm /query /status 2>&1 | Out-String);Source=(w32tm /query /source 2>&1)}
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
# Source: Verified from learn.microsoft.com/windows-server/networking/windows-time-service/windows-time-service-tools-and-settings
