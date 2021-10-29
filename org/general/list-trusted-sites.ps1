<#
  .SYNOPSIS
  List Url/Zone pairs in an Intune Windows 10 Trusted Sites Policy

  .DESCRIPTION
  List Url/Zone pairs in an Intune Windows 10 Trusted Sites Policy

  .NOTES
  Permissions: MS Graph API permissions:
  - DeviceManagementConfiguration.ReadWrite.All
   
  This runbook uses calls as descrobed in 
  https://call4cloud.nl/2021/09/the-isencrypted-with-steve-zissou/
  to decrypt omaSettings. It currently needs to use the MS Graph Beta Endpoint for this. 
  Please switch to "v1.0" as soon, as this funtionality is available.

  .INPUTS
  RunbookCustomization: {
        "Parameters": {
            "DumpAllPolicies": {
                "Select": {
                    "Options": [
                        {
                            "Display": "List only from one specific policiy",
                            "ParameterValue": false
                        }, 
                        {
                            "Display": "List from all policies",
                            "ParameterValue": true,
                            "Customization": {
                                "Hide": [
                                    "IntunePolicyName"
                                ]

                            }
                        }
                    ]
                }
            }
        }
    }
#>

#>

#Requires -Modules @{ModuleName = "RealmJoin.RunbookHelper"; ModuleVersion = "0.6.0" }

param(
    [boolean] $DumpAllPolicies = $false,
    [string] $IntunePolicyName = "Windows 10 - Trusted Sites"
)

Connect-RjRbGraph

$pol = $null

if (-not $DumpAllPolicies) {
    [array]$pol = Invoke-RjRbRestMethodGraph -resource "/deviceManagement/deviceConfigurations" -OdFilter "displayName eq '$intunePolicyName'" -Beta
    if (-not $pol) {
        throw "Policy '$intunePolicyName' not found."
    }
}
else {
    $AllPol = Invoke-RjRbRestMethodGraph -resource "/deviceManagement/deviceConfigurations" -Beta
    [array]$pol = $AllPol | Where-Object { $_.omaSettings.omaUri -eq "./User/Vendor/MSFT/Policy/Config/InternetExplorer/AllowSiteToZoneAssignmentList" }
}

$pol | ForEach-Object {
    ""
    "## Policy: $($_.displayName)"
    ""
    $omaValue = Invoke-RjRbRestMethodGraph -Beta -resource "/deviceManagement/deviceConfigurations/$($_.id)/getOmaSettingPlainTextValue(secretReferenceValueId='$($_.omaSettings.secretReferenceValueId)')"
    $innerValue = ($omaValue.split('"')[3]) -replace ('&#xF000;', ';') 
    [array]$pairs = $innerValue.Split(';')
    if (($pairs.Count % 2) -eq 0) {
        [int]$i = 0;
        $mappings = @{}
        do {
            $mappings.Add($pairs[$i], $pairs[$i + 1])
            $i = $i + 2
        } while ($i -lt $pairs.Count)
        $mappings | Format-Table -AutoSize | Out-String
    }
    else {
        throw "Error in parsing policy!"
    }
}