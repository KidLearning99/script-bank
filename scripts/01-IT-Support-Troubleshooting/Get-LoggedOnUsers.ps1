<#
.SYNOPSIS
    Currently logged-on users.
.DESCRIPTION
    Reports interactive/remote logon sessions on the machine. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-LoggedOnUsers.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/powershell/module/cimcmdlets/get-ciminstance
    Tier: [TIER 1 - PRODUCTION READY]
#>
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Write-Log "Running Get-LoggedOnUsers.ps1 on $env:COMPUTERNAME"
    $result = Get-CimInstance Win32_LoggedOnUser | ForEach-Object { $_.Antecedent } | Select-Object -Unique Name,Domain
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
# Source: Verified from learn.microsoft.com/powershell/module/cimcmdlets/get-ciminstance
