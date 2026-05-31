<#
.SYNOPSIS
    All guest (B2B) accounts.
.DESCRIPTION
    Inventories external guest users in the tenant. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-EntraGuestUsers.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/graph/api/user-list
    Tier: [TIER 1 - PRODUCTION READY]
    Permissions (Graph scopes, read): User.Read.All
    Modules: Microsoft.Graph.Authentication, Microsoft.Graph.Users
#>
#Requires -Modules Microsoft.Graph.Authentication
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Connect-MgGraph -Scopes 'User.Read.All' -NoWelcome -ErrorAction Stop
    Write-Log "Connected to Microsoft Graph"
    $result = Get-MgUser -All -Filter "userType eq 'Guest'" -Property displayName,userPrincipalName,mail,createdDateTime | Select-Object DisplayName,UserPrincipalName,Mail,CreatedDateTime
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
finally { Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null }
# Source: Verified from learn.microsoft.com/graph/api/user-list
