<#
.SYNOPSIS
    Mail flow (transport) rules.
.DESCRIPTION
    Inventories transport rules and their state. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-TransportRuleInventory.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/powershell/module/exchange/get-transportrule
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
    $result = Get-TransportRule | Select-Object Name,State,Priority,Description
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
finally { Disconnect-ExchangeOnline -Confirm:$false -ErrorAction SilentlyContinue }
# Source: Verified from learn.microsoft.com/powershell/module/exchange/get-transportrule
