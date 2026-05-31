<#
.SYNOPSIS
    Computer accounts inactive beyond N days.
.DESCRIPTION
    Reports stale computer objects by LastLogonTimeStamp. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-ADStaleComputers.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/powershell/module/activedirectory/get-adcomputer
    Tier: [TIER 1 - PRODUCTION READY]
    Modules: ActiveDirectory (RSAT)
#>
#Requires -Modules ActiveDirectory
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Write-Log "Running Get-ADStaleComputers.ps1"
    $result = $c=(Get-Date).AddDays(-90); Get-ADComputer -Filter 'Enabled -eq $true' -Properties LastLogonTimeStamp | Where-Object {$_.LastLogonTimeStamp -and [datetime]::FromFileTime($_.LastLogonTimeStamp) -lt $c} | Select-Object Name,@{N='LastLogon';E={[datetime]::FromFileTime($_.LastLogonTimeStamp)}}
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
# Source: Verified from learn.microsoft.com/powershell/module/activedirectory/get-adcomputer
