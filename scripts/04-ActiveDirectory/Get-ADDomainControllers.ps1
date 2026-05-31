<#
.SYNOPSIS
    Domain controllers in the domain.
.DESCRIPTION
    Lists DCs with site, OS and roles. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-ADDomainControllers.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/powershell/module/activedirectory/get-addomaincontroller
    Tier: [TIER 1 - PRODUCTION READY]
    Modules: ActiveDirectory (RSAT)
#>
#Requires -Modules ActiveDirectory
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Write-Log "Running Get-ADDomainControllers.ps1"
    $result = Get-ADDomainController -Filter * | Select-Object HostName,Site,OperatingSystem,IsGlobalCatalog,IPv4Address
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
# Source: Verified from learn.microsoft.com/powershell/module/activedirectory/get-addomaincontroller
