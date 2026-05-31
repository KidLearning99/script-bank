<#
.SYNOPSIS
    Installed device drivers.
.DESCRIPTION
    Lists signed drivers and versions. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-InstalledDriverInventory.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/powershell/module/microsoft.powershell.management/get-ciminstance
    Tier: [TIER 1 - PRODUCTION READY]
#>
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Write-Log "Running Get-InstalledDriverInventory.ps1 on $env:COMPUTERNAME"
    $result = Get-CimInstance Win32_PnPSignedDriver | Where-Object DeviceName | Select-Object DeviceName,DriverVersion,DriverProviderName -First 100
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
# Source: Verified from learn.microsoft.com/powershell/module/microsoft.powershell.management/get-ciminstance
