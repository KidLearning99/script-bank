<#
.SYNOPSIS
    Members of the local Administrators group.
.DESCRIPTION
    Audits who has local admin rights on the machine. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-LocalAdminMembers.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/powershell/module/microsoft.powershell.localaccounts/get-localgroupmember
    Tier: [TIER 1 - PRODUCTION READY]
#>
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Write-Log "Running Get-LocalAdminMembers.ps1 on $env:COMPUTERNAME"
    $result = Get-LocalGroupMember -Group 'Administrators' | Select-Object Name,ObjectClass,PrincipalSource
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
# Source: Verified from learn.microsoft.com/powershell/module/microsoft.powershell.localaccounts/get-localgroupmember
