<#
.SYNOPSIS
    Owners of each group.
.DESCRIPTION
    Reports owners for groups (governance review). Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-EntraGroupOwnersReport.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/graph/api/group-list-owners
    Tier: [TIER 1 - PRODUCTION READY]
    Permissions (Graph scopes, read): Group.Read.All, User.Read.All
    Modules: Microsoft.Graph.Authentication, Microsoft.Graph.Groups
#>
#Requires -Modules Microsoft.Graph.Authentication
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Connect-MgGraph -Scopes 'Group.Read.All','User.Read.All' -NoWelcome -ErrorAction Stop
    Write-Log "Connected to Microsoft Graph"
    $result = Get-MgGroup -All | ForEach-Object { $g=$_; (Get-MgGroupOwner -GroupId $_.Id -EA SilentlyContinue) | ForEach-Object { [pscustomobject]@{Group=$g.DisplayName;OwnerId=$_.Id} } }
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
finally { Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null }
# Source: Verified from learn.microsoft.com/graph/api/group-list-owners
