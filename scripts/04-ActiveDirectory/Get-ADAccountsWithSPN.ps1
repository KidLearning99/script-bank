<#
.SYNOPSIS
    User accounts with SPNs (Kerberoast risk).
.DESCRIPTION
    Flags user accounts carrying service principal names. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-ADAccountsWithSPN.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/powershell/module/activedirectory/get-aduser
    Tier: [TIER 1 - PRODUCTION READY]
    Modules: ActiveDirectory (RSAT)
#>
#Requires -Modules ActiveDirectory
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Write-Log "Running Get-ADAccountsWithSPN.ps1"
    $result = Get-ADUser -Filter 'ServicePrincipalName -like "*"' -Properties ServicePrincipalName | Select-Object Name,SamAccountName,@{N='SPNs';E={$_.ServicePrincipalName -join '; '}}
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
# Source: Verified from learn.microsoft.com/powershell/module/activedirectory/get-aduser
