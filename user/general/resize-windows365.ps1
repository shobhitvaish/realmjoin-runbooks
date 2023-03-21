<#
 .SYNOPSIS
 Resize a Windows 365 Cloud PC

 .DESCRIPTION
 Resize an already existing Windows 365 Cloud PC by derpovisioning and assigning a new differently sized license to the user. Warning: All local data will be lost. Proceed with caution.

 .NOTES
 Permissions:
 MS Graph (API):
 - GroupMember.ReadWrite.All 
 - Group.ReadWrite.All
 - Directory.Read.All
 - CloudPC.ReadWrite.All (Beta)
 - User.Read.All
 - User.SendMail

 .INPUTS
 RunbookCustomization: {
 "Parameters": {
    "UserName": {
        "Hide": true
    },
    "CallerName": {
        "Hide": true
    },
    "currentLicWin365GroupName": {
        "SelectSimple": {
            "lic - Windows 365 Enterprise - 2 vCPU 4 GB 128 GB": "lic - Windows 365 Enterprise - 2 vCPU 4 GB 128 GB",
            "lic - Windows 365 Enterprise - 2 vCPU 4 GB 256 GB": "lic - Windows 365 Enterprise - 2 vCPU 4 GB 256 GB"
        }
    },
    "newLicWin365GroupName": {
        "SelectSimple": {
            "lic - Windows 365 Enterprise - 2 vCPU 4 GB 128 GB": "lic - Windows 365 Enterprise - 2 vCPU 4 GB 128 GB",
            "lic - Windows 365 Enterprise - 2 vCPU 4 GB 256 GB": "lic - Windows 365 Enterprise - 2 vCPU 4 GB 256 GB"
        }
    },
    "sendMailWhenResizing": {
            "DisplayName": "Notify user when CloudPC resizing has begun?",
            "Select": {
                "Options": [
                    {
                        "Display": "Do not send an Email.",
                        "ParameterValue": false,
                        "Customization": {
                            "Hide": [
                                "fromMailAddress"
                            ]
                        }
                    },
                    {
                        "Display": "Send an Email.",
                        "ParameterValue": true
                    }
                ]
            }
        }
    }
 }
 
 .EXAMPLE
 "user_general_resizing-windows365": {
    "Parameters": {
        "licWin365GroupName": {
            "SelectSimple": {
                "lic - Windows 365 Enterprise - 2 vCPU 4 GB 128 GB": "lic - Windows 365 Enterprise - 2 vCPU 4 GB 128 GB",
                "lic - Windows 365 Enterprise - 2 vCPU 4 GB 256 GB": "lic - Windows 365 Enterprise - 2 vCPU 4 GB 256 GB"
            }
        }
    }
 }

#>

#Requires -Modules @{ModuleName = "RealmJoin.RunbookHelper"; ModuleVersion = "0.6.0" }

param(
    [Parameter(Mandatory = $true)]
    [ValidateScript( { Use-RJRbInterface -Type Graph -Entity User -DisplayName "User" } )]
    [string] $UserName,
    [ValidateScript( { Use-RJInterface -DisplayName "The to-be-resized Cloud PC uses the following Windows365 license: " } )]
    [Parameter(Mandatory = $true)]
    [string] $currentLicWin365GroupName="lic - Windows 365 Enterprise - 2 vCPU 4 GB 128 GB",
    [ValidateScript( { Use-RJInterface -DisplayName "Resizing to following license: " } )]
    [Parameter(Mandatory = $true)]
    [string] $newLicWin365GroupName="lic - Windows 365 Enterprise - 2 vCPU 4 GB 256 GB",
    [bool] $sendMailWhenReprovisioning = $false,
    [ValidateScript( { Use-RJInterface -DisplayName "(Shared) Mailbox to send mail from: " } )]
    [string] $fromMailAddress = "reports@contoso.com",
    # CallerName is tracked purely for auditing purposes
    [Parameter(Mandatory = $true)]
    [string] $CallerName
)

Logging Caller
Write-RjRbLog -Message "Caller: '$CallerName'" -Verbose

Connect-RjRbGraph

# User exists?
$targetUser = Invoke-RjRbRestMethodGraph -Resource "/users" -OdFilter "userPrincipalName eq '$UserName'" -ErrorAction SilentlyContinue
if (-not $targetUser) {
    throw ("User $UserName not found.")
}

# Fetch the user selected license 
$currentLicWin365GroupObj = Invoke-RjRbRestMethodGraph -Resource "/groups" -OdFilter "displayName eq '$currentLicWin365GroupName'"

# Find which of the licenses are in use/assigned to the user
$result = Invoke-RjRbRestMethodGraph -Resource "/groups/$($licWin365GroupObj.id)/members"

if ($result -and ($result.userPrincipalName -contains $UserName)) {
    $assignedLicenses = invoke-RjRbRestMethodGraph -Resource "/groups/$($currentlicWin365GroupObj.id)/assignedLicenses"
    
}