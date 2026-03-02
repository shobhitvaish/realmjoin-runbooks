# Import Guest Inviters As Sponsors

Set the guest inviter as sponsor for guest users.

## Detailed description
Updates the Sponsors attribute to include the user who initially invited the guest to the tenant using the InvitedBy property.
This script can be used to backfill Sponsors attribute for existing guest users who don't have sponsors assigned yet.

## Where to find
Org \ Guest Lifecycle \ Import Guest Inviters As Sponsors

## Notes
This script is based on the following approach:
https://github.com/AzureAD/MSIdentityTools/blob/main/src/Update-MsIdInvitedUserSponsorsFromInvitedBy.ps1

## Parameters
### UserIds
User Principal Name or Object ID of specific guest user(s) to process. If not provided, all invited guests will be processed.

| Property | Value |
|----------|-------|
| Default Value |  |
| Required | false |
| Type | String Array |

### SponsorInclusionGroupId
If provided, only users who are members of this security group are allowed to be assigned as guest sponsors.

| Property | Value |
|----------|-------|
| Default Value |  |
| Required | false |
| Type | String |

### SponsorExclusionGroupId
If provided, users who are members of this security group are excluded from being assigned as guest sponsors.

| Property | Value |
|----------|-------|
| Default Value |  |
| Required | false |
| Type | String |

### CsvDelimiter
The delimiter to use in the CSV output. Default is ";".

| Property | Value |
|----------|-------|
| Default Value | ; |
| Required | false |
| Type | String |

### DryRun
If enabled, the guest invitations are checked but the guest user objects are not modified.

| Property | Value |
|----------|-------|
| Default Value | False |
| Required | false |
| Type | Boolean |


[Back to Table of Content](../../../README.md)

