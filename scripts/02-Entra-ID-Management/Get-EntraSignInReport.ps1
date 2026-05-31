<#
.SYNOPSIS
    Recent interactive sign-ins.
.DESCRIPTION
    Reports recent sign-in events with status and location. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-EntraSignInReport.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/graph/api/signin-list
    Tier: [TIER 1 - PRODUCTION READY]
    Permissions (Graph scopes, read): AuditLog.Read.All
    Modules: Microsoft.Graph.Authentication
#>
#Requires -Modules Microsoft.Graph.Authentication
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Connect-MgGraph -Scopes 'AuditLog.Read.All' -NoWelcome -ErrorAction Stop
    Write-Log "Connected to Microsoft Graph"
    $result = (Invoke-MgGraphRequest -Method GET -Uri 'https://graph.microsoft.com/v1.0/auditLogs/signIns?$top=50').value | ForEach-Object { [pscustomobject]@{User=$_.userPrincipalName;App=$_.appDisplayName;Status=$_.status.errorCode;City=$_.location.city;Time=$_.createdDateTime} }
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
finally { Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null }
# Source: Verified from learn.microsoft.com/graph/api/signin-list
