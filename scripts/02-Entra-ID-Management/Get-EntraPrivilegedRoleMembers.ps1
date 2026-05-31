<#
.SYNOPSIS
    Members of privileged directory roles.
.DESCRIPTION
    Audits who holds admin roles like Global Administrator. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-EntraPrivilegedRoleMembers.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/graph/api/directoryrole-list
    Tier: [TIER 1 - PRODUCTION READY]
    Permissions (Graph scopes, read): RoleManagement.Read.Directory, Directory.Read.All
    Modules: Microsoft.Graph.Authentication, Microsoft.Graph.Identity.DirectoryManagement
#>
#Requires -Modules Microsoft.Graph.Authentication
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Connect-MgGraph -Scopes 'RoleManagement.Read.Directory','Directory.Read.All' -NoWelcome -ErrorAction Stop
    Write-Log "Connected to Microsoft Graph"
    $result = Get-MgDirectoryRole -All | ForEach-Object { $r=$_; Get-MgDirectoryRoleMember -DirectoryRoleId $_.Id -EA SilentlyContinue | ForEach-Object { [pscustomobject]@{Role=$r.DisplayName;MemberId=$_.Id} } }
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
finally { Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null }
# Source: Verified from learn.microsoft.com/graph/api/directoryrole-list
