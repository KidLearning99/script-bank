<#
.SYNOPSIS
    Scheduled tasks with last result not zero.
.DESCRIPTION
    Flags tasks whose last run failed. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-ScheduledTaskHealth.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/powershell/module/scheduledtasks/get-scheduledtaskinfo
    Tier: [TIER 1 - PRODUCTION READY]
#>
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Write-Log "Running Get-ScheduledTaskHealth.ps1 on $env:COMPUTERNAME"
    $result = Get-ScheduledTask | ForEach-Object { $i=$_ | Get-ScheduledTaskInfo; if($i.LastTaskResult -ne 0){ [pscustomobject]@{Task=$_.TaskName;LastResult=$i.LastTaskResult;LastRun=$i.LastRunTime} } }
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
# Source: Verified from learn.microsoft.com/powershell/module/scheduledtasks/get-scheduledtaskinfo
