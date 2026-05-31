<#
.SYNOPSIS
    DHCP scopes and utilization (DHCP role).
.DESCRIPTION
    Reports DHCP scopes and address usage. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-DhcpScopeReport.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/powershell/module/dhcpserver/get-dhcpserverv4scopestatistics
    Tier: [TIER 1 - PRODUCTION READY]
#>
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Write-Log "Running Get-DhcpScopeReport.ps1 on $env:COMPUTERNAME"
    $result = Import-Module DhcpServer -EA SilentlyContinue; Get-DhcpServerv4Scope | ForEach-Object { $st=$_ | Get-DhcpServerv4ScopeStatistics; [pscustomobject]@{Scope=$_.Name;Range="$($_.StartRange)-$($_.EndRange)";PercentInUse=$st.PercentageInUse} }
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
# Source: Verified from learn.microsoft.com/powershell/module/dhcpserver/get-dhcpserverv4scopestatistics
