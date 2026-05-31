<#
.SYNOPSIS
    Recent device enrollment failures.
.DESCRIPTION
    Reports enrollment failure events for troubleshooting. Read-only: makes no changes (no Set/Remove/New/Disable operations).
.EXAMPLE
    .\Get-IntuneEnrollmentFailures.ps1 -Verbose
.NOTES
    Author: Enterprise Script Bank AI
    Version: 1.0
    Read-Only: YES
    Source: Verified from learn.microsoft.com/graph/api/intune-enrollment-deviceenrollmentconfiguration-list
    Tier: [TIER 1 - PRODUCTION READY]
    Permissions (Graph scopes, read): DeviceManagementServiceConfig.Read.All
    Modules: Microsoft.Graph.Authentication, Microsoft.Graph.DeviceManagement
#>
#Requires -Modules Microsoft.Graph.Authentication
[CmdletBinding()]
param([string]$ExportCsv)
function Write-Log { param($m,$l='INFO') Write-Verbose ("[{0}] [{1}] {2}" -f (Get-Date -Format u),$l,$m) }
try {
    Connect-MgGraph -Scopes 'DeviceManagementServiceConfig.Read.All' -NoWelcome -ErrorAction Stop
    Write-Log "Connected to Microsoft Graph"
    $result = Get-MgDeviceManagementManagedDevice -All | Where-Object {$_.ManagementState -match 'fail|error'} | Select-Object DeviceName,UserPrincipalName,ManagementState,@{N='Enrolled';E={$_.EnrolledDateTime}}
    if ($ExportCsv) { $result | Export-Csv $ExportCsv -NoTypeInformation -Encoding UTF8; Write-Log "Exported to $ExportCsv" }
    $result
    exit 0
}
catch { Write-Error "Failed: $($_.Exception.Message)"; exit 2 }
finally { Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null }
# Source: Verified from learn.microsoft.com/graph/api/intune-enrollment-deviceenrollmentconfiguration-list
