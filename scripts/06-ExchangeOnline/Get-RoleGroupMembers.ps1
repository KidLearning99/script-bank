<#
.SYNOPSIS
    Members of Exchange admin role groups.
.DESCRIPTION
    Audits Exchange Online RBAC role group membership. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-RoleGroupMembers.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/powershell/module/exchange/get-rolegroup
    Tier: [TIER 1 - PRODUCTION READY]
    Modules: ExchangeOnlineManagement
    Permissions: View-Only Recipients / Exchange Recipient Reader
#>
#Requires -Modules ExchangeOnlineManagement
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Connect-ExchangeOnline -ShowBanner:$false -ErrorAction Stop
    Write-Log "Connected to Exchange Online"
    $result = Get-RoleGroup | ForEach-Object { $g=$_; Get-RoleGroupMember -Identity $_.Identity -EA SilentlyContinue | ForEach-Object { [pscustomobject]@{RoleGroup=$g.Name;Member=$_.Name} } }
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
finally { Disconnect-ExchangeOnline -Confirm:$false -ErrorAction SilentlyContinue }
# Source: Verified from learn.microsoft.com/powershell/module/exchange/get-rolegroup
