<#
.SYNOPSIS
    Physical disk health (SMART).
.DESCRIPTION
    Reports physical disk reliability/health status. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-DiskSmartHealth.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/powershell/module/storage/get-physicaldisk
    Tier: [TIER 1 - PRODUCTION READY]
#>
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Write-Log "Running Get-DiskSmartHealth.ps1 on $env:COMPUTERNAME"
    $result = Get-PhysicalDisk | Select-Object DeviceId,FriendlyName,MediaType,HealthStatus,OperationalStatus,@{N='SizeGB';E={[math]::Round($_.Size/1GB)}}
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
# Source: Verified from learn.microsoft.com/powershell/module/storage/get-physicaldisk
