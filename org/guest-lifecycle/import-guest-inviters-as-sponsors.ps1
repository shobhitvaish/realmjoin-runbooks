<#
    .SYNOPSIS
        Set the guest inviter as sponsor for guest users.

    .DESCRIPTION
        Updates the Sponsors attribute to include the user who initially invited the guest to the tenant using the InvitedBy property.
        This script can be used to backfill Sponsors attribute for existing guest users who don't have sponsors assigned yet.

    .PARAMETER UserIds
        User Principal Name or Object ID of specific guest user(s) to process. If not provided, all invited guests will be processed.

    .PARAMETER SponsorInclusionGroupId  
        If provided, only users who are members of this security group are allowed to be assigned as guest sponsors.
        
    .PARAMETER SponsorExclusionGroupId
        If provided, users who are members of this security group are excluded from being assigned as guest sponsors.

    .PARAMETER DryRun
        If enabled, the guest invitations are checked but the guest user objects are not modified.

    .PARAMETER CsvDelimiter
        The delimiter to use in the CSV output. Default is ";".

    .INPUTS
    RunbookCustomization: {
        "Parameters": {
            "UserIds": {
                "DisplayName": "User ID(s) (Optional - leave empty to process all guests)"
            },            
            "SponsorInclusionGroupId": {
                "DisplayName": "Sponsor Inclusion Group ID (Optional)"
            },
            "SponsorExclusionGroupId": {
                "DisplayName": "Sponsor Exclusion Group ID (Optional)"
            },
            "CsvDelimiter": {
                "DisplayName": "CSV Delimiter"
            },
            "DryRun": {
                "DisplayName": "Dry Run (No Changes)"
            },
            "CallerName": {
                "Hide": true
            }
        }
    }

    .NOTES    
        This script is based on the following approach:
        https://github.com/AzureAD/MSIdentityTools/blob/main/src/Update-MsIdInvitedUserSponsorsFromInvitedBy.ps1
#>

#Requires -Modules @{ModuleName = "RealmJoin.RunbookHelper"; ModuleVersion = "0.8.4" }

param(
    [string[]] $UserIds,
    [ValidateScript( { Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process; Use-RJInterface -Type Setting -Attribute "GuestLifecycle.Scope.SponsorInclusionGroupId" } )]
    [string] $SponsorInclusionGroupId,
    [ValidateScript( { Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process; Use-RJInterface -Type Setting -Attribute "GuestLifecycle.Scope.SponsorExclusionGroupId" } )]
    [string] $SponsorExclusionGroupId,
    [ValidateScript( { Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process; Use-RJInterface -Type Setting -Attribute "GuestLifecycle.CsvDelimiter" } )]
    [string] $CsvDelimiter = ";",
    [bool] $DryRun,
    # CallerName is tracked purely for auditing purposes
    [Parameter(Mandatory = $true)]
    [string] $CallerName
)

$ErrorActionPreference = "Stop"
$VerbosePreference = "Continue"

function Main {
    <#
        .SYNOPSIS
            Defines the main logic of the script.
    #>
    param()

    Write-RjRbLog -Message "Caller: '$CallerName'" -Verbose

    if ($DryRun) {
        Write-RjRbLog -Message "DryRun activated" -Verbose
    }

    # Connect to Microsoft Graph API
    Connect-RjRbGraph

    Write-RjRbLog "--- Get invited guests ---" -Verbose
    $invitedGuests = Get-InvitedGuests
    Write-RjRbLog "---" -Verbose

    Write-RjRbLog "--- Get valid sponsors ---" -Verbose
    $validSponsors = Get-ValidSponsors
    Write-RjRbLog "---" -Verbose    

    Write-RjRbLog "--- Process invited guests and set inviter as sponsor ---" -Verbose
    $results = Set-GuestInvitersAsSponsors -InvitedGuests $invitedGuests -ValidSponsors $validSponsors
    Write-RjRbLog "---" -Verbose

    # Output the results and errors
    Write-Results -Results $results
    $errors = $results | Where-Object { ![string]::IsNullOrEmpty($_.Error) }
    $errorCount = $errors.Count
    if ($errorCount -gt 0) {
        throw "$errorCount unexpected errors encountered"
    }
}

function Get-InvitedGuests {
    <#
        .SYNOPSIS
            Returns all invited guest users to process.
    #>
    param()

    $filter = "creationType eq 'Invitation'"
    $select = "id,userPrincipalName,displayName,creationType"
    $expand = "sponsors(`$select=id,userPrincipalName,displayName)"

    $guests = $null
    if ($null -ne $UserIds -and $UserIds.Count -gt 0) {
        # Process specific users
        Write-RjRbLog "Processing $($UserIds.Count) specified user(s)" -Verbose
        $guests = @()
        foreach ($id in $UserIds) {
            $user = Invoke-RjRbRestMethodGraph `
                -Resource "/users/$id" `
                -OdSelect $select `
                -UriQueryParam "`$expand=$expand"
            $guests += $user
        }
    }
    else {
        # Process all invited guests
        Write-RjRbLog "Fetching all invited guests from tenant" -Verbose
        $guests = Invoke-RjRbRestMethodGraph `
            -Resource "/users" `
            -OdFilter $filter `
            -OdSelect $select `
            -UriQueryParam "`$expand=$expand" `
            -FollowPaging
    }

    Write-RjRbLog "$($guests.Count) invited guest users returned from server" -Verbose
    return $guests
}

function Get-ValidSponsors {
    <#
        .SYNOPSIS
            Returns all users of the tenant who are valid sponsors.
    #>
    param()

    $filter = "userType eq 'Member'"  
    $select = "id,userPrincipalName"  
    $users = Invoke-RjRbRestMethodGraph `
        -Resource "/users" `
        -OdFilter $filter `
        -OdSelect $select `
        -FollowPaging
    Write-RjRbLog "$($users.Count) member users returned from server" -Verbose

    # Consider inclusion/exclusion groups
    $includedSponsors = $null
    $excludedSponsors = $null
    $checkSponsorInclusionGroup = ![string]::IsNullOrEmpty($SponsorInclusionGroupId) `
        -and (Test-HasGroupMembers -GroupId $SponsorInclusionGroupId)
    $checkSponsorExclusionGroup = ![string]::IsNullOrEmpty($SponsorExclusionGroupId) `
        -and (Test-HasGroupMembers -GroupId $SponsorExclusionGroupId)
    
    if ($checkSponsorInclusionGroup) {
        $includedSponsors = Get-GroupMembers -GroupId $SponsorInclusionGroupId
    }

    if ($checkSponsorExclusionGroup) {
        $excludedSponsors = Get-GroupMembers -GroupId $SponsorExclusionGroupId
    }

    $usersInScope = @()
    $usersTotalCount = 0
    $usersExcludedCount = 0
    foreach ($user in $users) {
        $usersTotalCount++
        $userIncluded = $true
        if ($checkSponsorInclusionGroup -and $null -ne $includedSponsors -and $includedSponsors.id -notcontains $user.id) {
            $userIncluded = $false
            $usersExcludedCount++         
        }

        if ($userIncluded -and $checkSponsorExclusionGroup -and $null -ne $excludedSponsors -and $excludedSponsors.id -contains $user.id) {
            $userIncluded = $false
            $usersExcludedCount++
        }

        if ($userIncluded) {
            $usersInScope += $user
        }
    }

    $usersIncludedCount = $usersTotalCount - $usersExcludedCount
    Write-RjRbLog "  $usersTotalCount total users returned from servers" -Verbose
    Write-RjRbLog "- $usersExcludedCount users out of scope according to the SponsorInclusionGroup/SponsorExclusionGroup" -Verbose
    Write-RjRbLog "= $usersIncludedCount users in scope" -Verbose

    return $usersInScope
}

function Set-GuestInvitersAsSponsors {
    <#
        .SYNOPSIS
            Processes all invited guests and sets inviter as sponsor if needed.
    #>
    param(       
        $InvitedGuests,
        $ValidSponsors
    )

    $results = @()
    foreach ($guest in $InvitedGuests) {
        try {
            $result = Set-GuestInviterAsSponsor -Guest $guest -ValidSponsors $ValidSponsors
            $results += $result
        }
        catch {
            # Catch error for the specific iterated object
            $result = [pscustomobject]@{
                "GuestId"    = $guest.id
                "GuestUPN"   = $guest.userPrincipalName
                "InviterId"  = $null
                "InviterUPN" = $null
                "Error"      = ($_ | Out-String)
            }
            $results += $result
            
            Write-RjRbLog "Unexpected error for guest with id `"$($guest.id)`" and UPN `"$($guest.userPrincipalName)`":" -Verbose
            Write-RjRbLog ($_ | Out-String) -Verbose
        }
    }

    return $results
}

function Set-GuestInviterAsSponsor {
    <#
        .SYNOPSIS
            Processes a single invited guest and sets inviter as sponsor if needed.
    #>
    param(       
        $Guest,
        $ValidSponsors
    )

    # Prepare result output
    $result = [pscustomobject]@{
        "GuestId"    = $Guest.id
        "GuestUPN"   = $Guest.userPrincipalName
        "InviterId"  = $null
        "InviterUPN" = $null
        "Action"     = $null
        "Error"      = $null
    }

    # Get invitedBy information using beta endpoint
    $invitedBy = $null
    try {
        $invitedBy = Invoke-RjRbRestMethodGraph `
            -Resource "/users/$($Guest.id)/invitedBy" `
            -Beta
    }
    catch {
        $result.Error = "Failed to retrieve invitedBy information"
        return $result
    }

    if ($null -eq $invitedBy -or $invitedBy.Count -eq 0) {
        $result.Action = "NoInviterFound"
        return $result
    }

    # Get the first inviter (should be only one)
    $inviter = $invitedBy[0]
    $result.InviterId = $inviter.id
    $result.InviterUPN = $inviter.userPrincipalName

    # Check if inviter is in scope (if sponsor scope filtering is enabled)
    if ($null -ne $ValidSponsors -and $ValidSponsors.Count -gt 0) {
        if ($ValidSponsors.id -notcontains $inviter.id) {
            $result.Action = "InviterNotValidSponsor"
            return $result
        }
    }

    # Check if inviter is already a sponsor
    $currentSponsors = $Guest.sponsors
    if ($null -ne $currentSponsors -and $currentSponsors.Count -gt 0) {
        if ($currentSponsors.id -contains $inviter.id) {
            $result.Action = "InviterAlreadySponsor"
            return $result
        }
    }

    # Add inviter as sponsor
    if (!$DryRun) {
        try {
            $sponsorBody = @{
                "@odata.id" = "https://graph.microsoft.com/v1.0/users/$($inviter.id)"    
            }

            Invoke-RjRbRestMethodGraph `
                -Resource "/users/$($Guest.id)/sponsors/`$ref" `
                -Method Post `
                -Body $sponsorBody | Out-Null
            
            $result.Action = "SponsorAdded"
        }
        catch {
            $result.Action = "Error"
            $result.Error = ($_ | Out-String)
        }
    }
    else {
        $result.Action = "SponsorAdded"
    }

    return $result
}

function Test-HasGroupMembers {
    <#
        .SYNOPSIS
            Checks whether the group has any members.
    #>
    param(
        [string] $GroupId
    )

    $groupMembers = Invoke-RjRbRestMethodGraph `
        -Resource "/groups/$GroupId/members" `
        -OdSelect "id" `
        -OdTop 1
    
    if ($null -eq $groupMembers -or $groupMembers.Count -eq 0) {
        return $false
    }
    
    return $true
}

function Get-GroupMembers {
    <#
        .SYNOPSIS
            Returns the transitive members of a group.
    #>
    param(
        [string] $GroupId
    )

    $select = "id,userPrincipalName"
    $groupMembers = Invoke-RjRbRestMethodGraph `
        -Resource "/groups/$GroupId/transitiveMembers" `
        -OdSelect $select `
        -FollowPaging    
    return $groupMembers
}

function Write-Results {
    <#
        .SYNOPSIS
            Write the results and errors to the output stream.
    #>
    param(
        $Results,
        [int] $BatchSize = 1000
    )

    Write-Output "--- Output results ---"
    $successResults = $Results | Where-Object { [string]::IsNullOrEmpty($_.Error) }
    Write-ObjectsAsTable -Objects $successResults -BatchSize $BatchSize
    Write-Output "---"

    Write-Output "--- Output errors ---"
    $errors = $Results | Where-Object { ![string]::IsNullOrEmpty($_.Error) }
    Write-ObjectsAsTable -Objects $errors -BatchSize $BatchSize
    Write-Output "---"
}

function Write-ObjectsAsTable {
    <#
        .SYNOPSIS
            Write objects in table format to the output stream.
    #>
    param(
        $Objects,
        [int] $BatchSize = 1000
    )

    if ($null -eq $Objects) {
        return
    }

    $objectsArray = @($Objects)
    if ($objectsArray.Count -eq 0) {
        return
    }

    $objectCount = $objectsArray.Count
    $batchCount = [Math]::Ceiling($objectCount / $BatchSize)
    for ($batchIndex = 0; $batchIndex -lt $batchCount; $batchIndex++) {
        $startIndex = $batchIndex * $BatchSize
        $endIndex = [Math]::Min($startIndex + $BatchSize - 1, $objectCount - 1)
        $batch = $objectsArray[$startIndex..$endIndex]
        $csvOutput = $batch | ConvertTo-Csv -Delimiter $CsvDelimiter -NoTypeInformation
        if ($null -ne $csvOutput -and $csvOutput.Count -gt 0) {
            $csvString = $csvOutput -join "`n"
            Write-Output $csvString
        }
    } 
}

# Start the Main function
Main