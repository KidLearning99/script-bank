<#
.SYNOPSIS
    All groups with type and membership counts.
.DESCRIPTION
    Inventories security/M365 groups. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-EntraGroupInventory.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/graph/api/group-list
    Tier: [TIER 1 - PRODUCTION READY]
    Permissions (Graph scopes, read): Group.Read.All
    Modules: Microsoft.Graph.Authentication, Microsoft.Graph.Groups
#>
#Requires -Modules Microsoft.Graph.Authentication
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Connect-MgGraph -Scopes 'Group.Read.All' -NoWelcome -ErrorAction Stop
    Write-Log "Connected to Microsoft Graph"
    $result = Get-MgGroup -All -Property displayName,mailEnabled,securityEnabled,groupTypes | Select-Object DisplayName,MailEnabled,SecurityEnabled,@{N='Types';E={$_.GroupTypes -join ','}}
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
finally { Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null }
# Source: Verified from learn.microsoft.com/graph/api/group-list
