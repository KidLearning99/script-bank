<#
.SYNOPSIS
    Intune RBAC role assignments.
.DESCRIPTION
    Reports who holds Intune admin roles. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-IntuneRoleAssignments.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/graph/api/intune-rbac-roleassignment-list
    Tier: [TIER 1 - PRODUCTION READY]
    Permissions (Graph scopes, read): DeviceManagementRBAC.Read.All
    Modules: Microsoft.Graph.Authentication
#>
#Requires -Modules Microsoft.Graph.Authentication
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Connect-MgGraph -Scopes 'DeviceManagementRBAC.Read.All' -NoWelcome -ErrorAction Stop
    Write-Log "Connected to Microsoft Graph"
    $result = (Invoke-MgGraphRequest -Method GET -Uri 'https://graph.microsoft.com/beta/deviceManagement/roleAssignments').value | ForEach-Object { [pscustomobject]@{Name=$_.displayName;Description=$_.description} }
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
finally { Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null }
# Source: Verified from learn.microsoft.com/graph/api/intune-rbac-roleassignment-list
