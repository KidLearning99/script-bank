<#
.SYNOPSIS
    Listening TCP ports and owning process.
.DESCRIPTION
    Reports listening endpoints for security review. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-OpenPortsReport.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/powershell/module/nettcpip/get-nettcpconnection
    Tier: [TIER 1 - PRODUCTION READY]
#>
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Write-Log "Running Get-OpenPortsReport.ps1 on $env:COMPUTERNAME"
    $result = Get-NetTCPConnection -State Listen | Select-Object LocalAddress,LocalPort,@{N='Process';E={(Get-Process -Id $_.OwningProcess -EA SilentlyContinue).ProcessName}} | Sort-Object LocalPort -Unique
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
# Source: Verified from learn.microsoft.com/powershell/module/nettcpip/get-nettcpconnection
