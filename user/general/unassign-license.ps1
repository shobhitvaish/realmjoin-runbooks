# This runbook will remove a license from a user via removing a group membership.
#
# This runbook will use the "AzureRunAsConnection" to connect to AzureAD. Please make sure, enough API-permissions are given to this service principal.
#
# Permissions:
#  AzureAD Roles
#   - User administrator

#Requires -Module MEMPSToolkit, @{ModuleName = "RealmJoin.RunbookHelper"; ModuleVersion = "0.4.0" }

param(
    [Parameter(Mandatory = $true)]
    [String] $UserName,
    [Parameter(Mandatory = $true)]
    [ValidateScript( { Use-RJInterface -Type Graph -Entity Group } )]
    [String] $GroupID_License
)

#region module check
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

Test-ModulePresent "MEMPSToolkit"
Test-ModulePresent "RealmJoin.RunbookHelper"
#endregion

#region authentication
# Automation credentials
Connect-RjRbGraph
#endregion

# Licensing group prefix
$groupPrefix = "LIC_"

# "Find select group from Object ID " + $GroupID_License
$group = Get-AADGroupById -groupId $GroupID_License -authToken $Global:RjRbGraphAuthHeaders
if (-not $group.displayName.startswith($groupPrefix)) {
    throw "`'$($group.displayName)`' is not a license assignment group. Will not proceed."
}

# "Find the user object " + $UserName) 
$targetUser = get-AADUserByUPN -userName $UserName -authToken $Global:RjRbGraphAuthHeaders
if ($null -eq $targetUser) {
    throw ("User $UserName not found.")
}

# "Is user member of the the group?"
$members = Get-AADGroupMembers -groupID $GroupID_License -authToken $Global:RjRbGraphAuthHeaders
if ($members.id -contains $targetUser.id) {
    "Removing license."
    Remove-AADGroupMember -groupID $GroupID_License -userID $targetUser.id -authToken $Global:RjRbGraphAuthHeaders | Out-Null
}
else {
    "License is not assigned. Doing nothing."
    
}

"`'$($group.displayName)`' is unassigned from `'$UserName`'"

