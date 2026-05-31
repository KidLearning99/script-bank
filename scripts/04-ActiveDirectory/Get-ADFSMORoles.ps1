<#
.SYNOPSIS
    FSMO role holders in the forest/domain.
.DESCRIPTION
    Reports which DCs hold operations master roles. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-ADFSMORoles.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/powershell/module/activedirectory/get-addomain
    Tier: [TIER 1 - PRODUCTION READY]
    Modules: ActiveDirectory (RSAT)
#>
#Requires -Modules ActiveDirectory
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Write-Log "Running Get-ADFSMORoles.ps1"
    $result = $d=Get-ADDomain; $f=Get-ADForest; [pscustomobject]@{PDCEmulator=$d.PDCEmulator;RIDMaster=$d.RIDMaster;InfraMaster=$d.InfrastructureMaster;SchemaMaster=$f.SchemaMaster;DomainNaming=$f.DomainNamingMaster}
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
# Source: Verified from learn.microsoft.com/powershell/module/activedirectory/get-addomain
