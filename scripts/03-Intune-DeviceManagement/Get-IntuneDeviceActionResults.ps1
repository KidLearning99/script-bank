<#
.SYNOPSIS
    Devices not checked in recently.
.DESCRIPTION
    Reports devices overdue for an Intune check-in. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-IntuneDeviceActionResults.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/graph/api/intune-devices-manageddevice-list
    Tier: [TIER 1 - PRODUCTION READY]
    Permissions (Graph scopes, read): DeviceManagementManagedDevices.Read.All
    Modules: Microsoft.Graph.Authentication, Microsoft.Graph.DeviceManagement
#>
#Requires -Modules Microsoft.Graph.Authentication
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Connect-MgGraph -Scopes 'DeviceManagementManagedDevices.Read.All' -NoWelcome -ErrorAction Stop
    Write-Log "Connected to Microsoft Graph"
    $result = $c=(Get-Date).AddDays(-7); Get-MgDeviceManagementManagedDevice -All | Where-Object {$_.LastSyncDateTime -lt $c} | Select-Object DeviceName,UserPrincipalName,@{N='LastSync';E={$_.LastSyncDateTime}}
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
finally { Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null }
# Source: Verified from learn.microsoft.com/graph/api/intune-devices-manageddevice-list
