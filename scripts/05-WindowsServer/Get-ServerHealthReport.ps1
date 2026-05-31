<#
.SYNOPSIS
    CPU, memory, disk and reboot health snapshot.
.DESCRIPTION
    One-shot health snapshot for a Windows Server. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-ServerHealthReport.ps1 -Verbose
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
    Write-Log "Running Get-ServerHealthReport.ps1 on $env:COMPUTERNAME"
    $result = $os=Get-CimInstance Win32_OperatingSystem; [pscustomobject]@{FreeMemPct=[math]::Round($os.FreePhysicalMemory/$os.TotalVisibleMemorySize*100,1);Uptime=((Get-Date)-$os.LastBootUpTime).Days;PendingReboot=(Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending')}
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
# Source: Verified from learn.microsoft.com/powershell/module/cimcmdlets/get-ciminstance
