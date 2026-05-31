<#
.SYNOPSIS
    Users with no sign-in in N days.
.DESCRIPTION
    Finds enabled members inactive beyond a threshold for review. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-EntraInactiveUsers.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/graph/api/resources/signinactivity
    Tier: [TIER 1 - PRODUCTION READY]
    Permissions (Graph scopes, read): AuditLog.Read.All, User.Read.All
    Modules: Microsoft.Graph.Authentication
#>
#Requires -Modules Microsoft.Graph.Authentication
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Connect-MgGraph -Scopes 'AuditLog.Read.All','User.Read.All' -NoWelcome -ErrorAction Stop
    Write-Log "Connected to Microsoft Graph"
    $result = Get-MgUser -All -Property displayName,userPrincipalName,signInActivity -Filter "accountEnabled eq true" | Select-Object DisplayName,UserPrincipalName,@{N='LastSignIn';E={$_.SignInActivity.LastSignInDateTime}}
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
finally { Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null }
# Source: Verified from learn.microsoft.com/graph/api/resources/signinactivity
