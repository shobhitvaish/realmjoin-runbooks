# This runbook will remove a windows device from Intune, AzureAD and Autopilot.
# This will NOT wipe a device. (although company user data and configs are removed from the client when it checks in.)
# 
# Be aware 
# - this runbook uses MS Graph "Beta" functionality and might break at some point.
# - https://docs.microsoft.com/en-us/graph/api/device-delete?view=graph-rest-1.0&tabs=http says we can not use API permissions to delete AzureAD devices, but it works (now). Might break.
#
# Permissions (API):
# - DeviceManagementManagedDevices.PrivilegedOperations.All (Wipe,Retire / seems to allow us to delete from AzureAD)
# - DeviceManagementManagedDevices.ReadWrite.All (Delete Inunte Device)
# - DeviceManagementServiceConfig.ReadWrite.All (Delete Autopilot enrollment)

#Requires -Module RealmJoin.RunbookHelper, MEMPSToolkit

param (
    [Parameter(Mandatory = $true)]
    [string] $DeviceId,
    [Parameter(Mandatory = $true)]
    [string] $OrganizationId
)

#region Module check
function Test-ModulePresent {
    param(
        [Parameter(Mandatory = $true)]
        [string]$neededModule
    )
    if (-not (Get-Module -ListAvailable $neededModule)) {
        throw ($neededModule + " is not available and can not be installed automatically. Please check.")
    }
    else {
        Import-Module $neededModule
        # "Module " + $neededModule + " is available."
    }
}

Test-ModulePresent "RealmJoin.RunbookHelper"
Test-ModulePresent "MEMPSToolkit"
#endregion

#region Authentication
# "Connect to Graph API..."
Connect-RjRbGraph
#endregion

# "Searching DeviceId $DeviceID."
$targetDevice = Get-AadDevices -deviceId $DeviceId -authToken $Global:RjRbGraphAuthHeaders
if (-not $targetDevice) {
    throw ("DeviceId $DeviceId not found in AzureAD.")
} 

# Remove from AzureAD - we could wipe the device, but we could not continue the process here immediately -> different runbook.
"Deleting $($targetDevice.displayName) (Object ID $($targetDevice.id)) from AzureAD"
try {
    Remove-AadDevice -ObjectId $targetDevice.id -authToken $Global:RjRbGraphAuthHeaders | Out-Null
}
catch {
    throw "Deleting Object ID $($targetDevice.id) from AzureAD failed!"
}

# Remove from Intune
# "Searching DeviceId $DeviceID in Intune."
$mgdDevice = Get-ManagedDeviceByDeviceId -azureAdDeviceId $DeviceId -authToken $Global:RjRbGraphAuthHeaders
if (-not $mgdDevice) {
    "DeviceId $DeviceId not found in Intune."
}
else {
    "Deleting DeviceId $DeviceID (Intune ID: $($mgdDevice.id)) from Intune"
    try {
        Remove-ManagedDevice -id $mgdDevice.id -authToken $Global:RjRbGraphAuthHeaders | Out-Null
    }
    catch {
        throw "Deleting Intune ID: $($mgdDevice.id) from Intune failed!"
    }
}

# Remove from Autopilot
# "Searching DeviceId $DeviceID in Autopilot."
$apDevice = Get-WindowsAutopilotDeviceByDeviceId -azureAdDeviceId $DeviceId -authToken $Global:RjRbGraphAuthHeaders
if (-not $apDevice) {
    "DeviceId $DeviceId not found in Autopilot."
}
else {
    "Deleting DeviceId $DeviceID (Autopilot ID: $($apDevice.id)) from Autopilot"
    try {
        Remove-WindowsAutopilotDevice -id $apDevice.id -authToken $Global:RjRbGraphAuthHeaders | Out-Null
    }
    catch {
        throw "Deleting Autopilot ID: $($apDevice.id) from Autopilot failed!"
    }
}

""

"Device $($targetDevice.displayName) with DeviceId $DeviceId successfully removed."