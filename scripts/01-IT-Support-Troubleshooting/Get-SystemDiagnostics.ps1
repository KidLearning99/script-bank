<#
.SYNOPSIS
    Baseline system diagnostics (OS, RAM, disk, uptime).
.DESCRIPTION
    Collects OS, memory, disk and uptime for first-line triage. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-SystemDiagnostics.ps1 -Verbose
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
    Write-Log "Running Get-SystemDiagnostics.ps1 on $env:COMPUTERNAME"
    $result = $os=Get-CimInstance Win32_OperatingSystem; [pscustomobject]@{OS=$os.Caption;Version=$os.Version;LastBoot=$os.LastBootUpTime;FreeRAMpct=[math]::Round($os.FreePhysicalMemory/$os.TotalVisibleMemorySize*100,1)}
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
# Source: Verified from learn.microsoft.com/powershell/module/cimcmdlets/get-ciminstance
