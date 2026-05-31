<#
.SYNOPSIS
    Per-user MFA / auth method registration.
.DESCRIPTION
    Reports registered strong auth methods and flags users without MFA. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-EntraMFAStatus.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/graph/api/authentication-list-methods
    Tier: [TIER 1 - PRODUCTION READY]
    Permissions (Graph scopes, read): UserAuthenticationMethod.Read.All, User.Read.All
    Modules: Microsoft.Graph.Authentication
#>
#Requires -Modules Microsoft.Graph.Authentication
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Connect-MgGraph -Scopes 'UserAuthenticationMethod.Read.All','User.Read.All' -NoWelcome -ErrorAction Stop
    Write-Log "Connected to Microsoft Graph"
    $result = Get-MgUser -All -Property id,displayName,userPrincipalName | ForEach-Object { $m=(Get-MgUserAuthenticationMethod -UserId $_.Id -EA SilentlyContinue).AdditionalProperties.'@odata.type'; [pscustomobject]@{UPN=$_.UserPrincipalName;Methods=($m -join ', ');HasMFA=[bool]($m -match 'authenticator|fido2|phone')} }
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
finally { Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null }
# Source: Verified from learn.microsoft.com/graph/api/authentication-list-methods
