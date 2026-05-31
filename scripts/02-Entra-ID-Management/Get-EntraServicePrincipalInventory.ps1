<#
.SYNOPSIS
    Enterprise apps / service principals.
.DESCRIPTION
    Lists service principals and their enablement. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-EntraServicePrincipalInventory.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/graph/api/serviceprincipal-list
    Tier: [TIER 1 - PRODUCTION READY]
    Permissions (Graph scopes, read): Application.Read.All
    Modules: Microsoft.Graph.Authentication, Microsoft.Graph.Applications
#>
#Requires -Modules Microsoft.Graph.Authentication
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Connect-MgGraph -Scopes 'Application.Read.All' -NoWelcome -ErrorAction Stop
    Write-Log "Connected to Microsoft Graph"
    $result = Get-MgServicePrincipal -All -Property displayName,appId,accountEnabled,servicePrincipalType | Select-Object DisplayName,AppId,AccountEnabled,ServicePrincipalType
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
finally { Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null }
# Source: Verified from learn.microsoft.com/graph/api/serviceprincipal-list
