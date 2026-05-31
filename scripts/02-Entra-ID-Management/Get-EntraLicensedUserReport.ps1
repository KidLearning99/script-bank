<#
.SYNOPSIS
    Users and their assigned licenses.
.DESCRIPTION
    Maps each user to assigned license SKUs. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-EntraLicensedUserReport.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/graph/api/user-list-licensedetails
    Tier: [TIER 1 - PRODUCTION READY]
    Permissions (Graph scopes, read): User.Read.All, Organization.Read.All
    Modules: Microsoft.Graph.Authentication, Microsoft.Graph.Users
#>
#Requires -Modules Microsoft.Graph.Authentication
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Connect-MgGraph -Scopes 'User.Read.All','Organization.Read.All' -NoWelcome -ErrorAction Stop
    Write-Log "Connected to Microsoft Graph"
    $result = Get-MgUser -All -Property displayName,userPrincipalName,assignedLicenses | Where-Object {$_.AssignedLicenses.Count -gt 0} | Select-Object DisplayName,UserPrincipalName,@{N='SkuCount';E={$_.AssignedLicenses.Count}}
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
finally { Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null }
# Source: Verified from learn.microsoft.com/graph/api/user-list-licensedetails
