<#
.SYNOPSIS
    AD Sites and subnets.
.DESCRIPTION
    Reports replication subnets mapped to sites. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-ADReplicationSubnets.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/powershell/module/activedirectory/get-adreplicationsubnet
    Tier: [TIER 1 - PRODUCTION READY]
    Modules: ActiveDirectory (RSAT)
#>
#Requires -Modules ActiveDirectory
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Write-Log "Running Get-ADReplicationSubnets.ps1"
    $result = Get-ADReplicationSubnet -Filter * -Properties Site | Select-Object Name,@{N='Site';E={($_.Site -split ',')[0] -replace 'CN='}}
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
# Source: Verified from learn.microsoft.com/powershell/module/activedirectory/get-adreplicationsubnet
