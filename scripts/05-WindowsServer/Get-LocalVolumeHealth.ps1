<#
.SYNOPSIS
    Volume health and free space.
.DESCRIPTION
    Reports volume health status and capacity. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-LocalVolumeHealth.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/powershell/module/storage/get-volume
    Tier: [TIER 1 - PRODUCTION READY]
#>
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Write-Log "Running Get-LocalVolumeHealth.ps1 on $env:COMPUTERNAME"
    $result = Get-Volume | Where-Object DriveLetter | Select-Object DriveLetter,FileSystemLabel,HealthStatus,@{N='FreeGB';E={[math]::Round($_.SizeRemaining/1GB,1)}},@{N='SizeGB';E={[math]::Round($_.Size/1GB,1)}}
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
# Source: Verified from learn.microsoft.com/powershell/module/storage/get-volume
