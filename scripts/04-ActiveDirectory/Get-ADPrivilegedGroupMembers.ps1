<#
.SYNOPSIS
    Members of privileged AD groups.
.DESCRIPTION
    Audits Domain/Enterprise/Schema Admins membership. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-ADPrivilegedGroupMembers.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/powershell/module/activedirectory/get-adgroupmember
    Tier: [TIER 1 - PRODUCTION READY]
    Modules: ActiveDirectory (RSAT)
#>
#Requires -Modules ActiveDirectory
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Write-Log "Running Get-ADPrivilegedGroupMembers.ps1"
    $result = 'Domain Admins','Enterprise Admins','Schema Admins' | ForEach-Object { $g=$_; Get-ADGroupMember -Identity $g -Recursive -EA SilentlyContinue | ForEach-Object { [pscustomobject]@{Group=$g;Member=$_.SamAccountName;Class=$_.objectClass} } }
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
# Source: Verified from learn.microsoft.com/powershell/module/activedirectory/get-adgroupmember
