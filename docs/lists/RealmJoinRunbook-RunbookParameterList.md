<a name='runbook-parameter-overview'></a>
# Overview
This document provides a comprehensive overview of all parameters used in the runbooks available in the RealmJoin portal. Each parameter is listed with its type and whether it is required or optional.

To ensure easy navigation, the runbooks are categorized into different sections based on their area of application. The following categories are currently available:
- device
- group
- org
- user

Each category contains multiple runbooks that are further divided into subcategories based on their functionality. For runbooks with multiple parameters, each parameter is listed in a separate row.

# Table of Contents
- [Device](#device)
  - [General](#device-general)
    - [Change Grouptag](#device-general-change-grouptag)
    - [Check Updatable Assets](#device-general-check-updatable-assets)
  - [Security](#device-security)
    - [Enable Or Disable Device](#device-security-enable-or-disable-device)
    - [Isolate Or Release Device](#device-security-isolate-or-release-device)
- [Group](#group)
  - [General](#group-general)
    - [Add Or Remove Nested Group](#group-general-add-or-remove-nested-group)
    - [Add Or Remove Owner](#group-general-add-or-remove-owner)
    - [Add Or Remove User](#group-general-add-or-remove-user)
  - [Mail](#group-mail)
    - [Enable Or Disable External Mail](#group-mail-enable-or-disable-external-mail)
    - [Show Or Hide In Address Book](#group-mail-show-or-hide-in-address-book)
- [User](#user)
  - [General](#user-general)
    - [Assign Groups By Template](#user-general-assign-groups-by-template)
    - [Assign Or Unassign License](#user-general-assign-or-unassign-license)
    - [Assign Windows365](#user-general-assign-windows365)
    - [List Group Memberships](#user-general-list-group-memberships)
  - [Mail](#user-mail)
    - [Add Or Remove Email Address](#user-mail-add-or-remove-email-address)
    - [Assign OWA Mailbox Policy](#user-mail-assign-owa-mailbox-policy)
    - [Convert To Shared Mailbox](#user-mail-convert-to-shared-mailbox)

<a name='device'></a>
# Device
<a name='device-general'></a>
## General

<a name='device-general-change-grouptag'></a>

### Change Grouptag
Assign a new Auto-pilot GroupTag to this device.

| Parameter | Required | Type | Description |
|-----------|----------|------|-------------|
| DeviceId | ✓ | String |  |
| newGroupTag |  | String |  |
| CallerName | ✓ | String |  |

<a name='device-general-check-updatable-assets'></a>

### Check Updatable Assets
Check if a device is onboarded to Windows Update for Business.

| Parameter | Required | Type | Description |
|-----------|----------|------|-------------|
| CallerName | ✓ | String | Caller name for auditing purposes. |
| DeviceId | ✓ | String | DeviceId of the device to check onboarding status for. |

[Back to the RealmJoin runbook parameter overview](#table-of-contents)

<a name='device-security'></a>
## Security

<a name='device-security-enable-or-disable-device'></a>

### Enable Or Disable Device
Disable a device in AzureAD.

| Parameter | Required | Type | Description |
|-----------|----------|------|-------------|
| DeviceId | ✓ | String |  |
| Enable |  | Boolean |  |
| CallerName | ✓ | String | CallerName is tracked purely for auditing purposes |

<a name='device-security-isolate-or-release-device'></a>

### Isolate Or Release Device
Isolate this device.

| Parameter | Required | Type | Description |
|-----------|----------|------|-------------|
| DeviceId | ✓ | String |  |
| Release | ✓ | Boolean |  |
| IsolationType |  | String |  |
| Comment | ✓ | String |  |
| CallerName | ✓ | String | CallerName is tracked purely for auditing purposes |

[Back to the RealmJoin runbook parameter overview](#table-of-contents)

<a name='group'></a>
# Group
<a name='group-general'></a>
## General

<a name='group-general-add-or-remove-nested-group'></a>

### Add Or Remove Nested Group
Add/remove a nested group to/from a group.

| Parameter | Required | Type | Description |
|-----------|----------|------|-------------|
| GroupID | ✓ | String |  |
| NestedGroupID | ✓ | String |  |
| Remove |  | Boolean |  |
| CallerName | ✓ | String | CallerName is tracked purely for auditing purposes |

<a name='group-general-add-or-remove-owner'></a>

### Add Or Remove Owner
Add/remove owners to/from an Office 365 group.

| Parameter | Required | Type | Description |
|-----------|----------|------|-------------|
| GroupID | ✓ | String |  |
| UserId | ✓ | String |  |
| Remove |  | Boolean |  |
| CallerName | ✓ | String | CallerName is tracked purely for auditing purposes |

<a name='group-general-add-or-remove-user'></a>

### Add Or Remove User
Add/remove users to/from a group.

| Parameter | Required | Type | Description |
|-----------|----------|------|-------------|
| GroupID | ✓ | String |  |
| UserId | ✓ | String |  |
| Remove |  | Boolean |  |
| CallerName | ✓ | String | CallerName is tracked purely for auditing purposes |

[Back to the RealmJoin runbook parameter overview](#table-of-contents)

<a name='group-mail'></a>
## Mail

<a name='group-mail-enable-or-disable-external-mail'></a>

### Enable Or Disable External Mail
Enable/disable external parties to send eMails to O365 groups.

| Parameter | Required | Type | Description |
|-----------|----------|------|-------------|
| GroupId | ✓ | String |  |
| Action |  | Int32 |  |
| CallerName | ✓ | String | CallerName is tracked purely for auditing purposes |

<a name='group-mail-show-or-hide-in-address-book'></a>

### Show Or Hide In Address Book
(Un)hide an O365- or static Distribution-group in Address Book.

| Parameter | Required | Type | Description |
|-----------|----------|------|-------------|
| GroupName | ✓ | String |  |
| Action |  | Int32 |  |
| CallerName | ✓ | String | CallerName is tracked purely for auditing purposes |

[Back to the RealmJoin runbook parameter overview](#table-of-contents)

<a name='user'></a>
# User
<a name='user-general'></a>
## General

<a name='user-general-assign-groups-by-template'></a>

### Assign Groups By Template
Assign cloud-only groups to a user based on a predefined template.

| Parameter | Required | Type | Description |
|-----------|----------|------|-------------|
| UserId | ✓ | String |  |
| GroupsTemplate |  | String | GroupsTemplate is not used directly, but is used to populate the GroupsString parameter via RJ Portal Customization |
| GroupsString | ✓ | String |  |
| UseDisplaynames |  | Boolean | $UseDisplayname = $false: GroupsString contains Group object ids, $true: GroupsString contains Group displayNames |
| CallerName | ✓ | String | CallerName is tracked purely for auditing purposes |

<a name='user-general-assign-or-unassign-license'></a>

### Assign Or Unassign License
(Un-)Assign a license to a user via group membership.

| Parameter | Required | Type | Description |
|-----------|----------|------|-------------|
| UserName | ✓ | String |  |
| GroupID_License | ✓ | String | production does not supprt "ref:LicenseGroup" yet |
| Remove |  | Boolean |  |
| CallerName | ✓ | String | CallerName is tracked purely for auditing purposes |

<a name='user-general-assign-windows365'></a>

### Assign Windows365
Assign/Provision a Windows 365 instance

| Parameter | Required | Type | Description |
|-----------|----------|------|-------------|
| UserName | ✓ | String |  |
| cfgProvisioningGroupName |  | String |  |
| cfgUserSettingsGroupName |  | String |  |
| licWin365GroupName |  | String |  |
| cfgProvisioningGroupPrefix |  | String |  |
| cfgUserSettingsGroupPrefix |  | String |  |
| sendMailWhenProvisioned |  | Boolean |  |
| customizeMail |  | Boolean |  |
| customMailMessage |  | String |  |
| createTicketOutOfLicenses |  | Boolean |  |
| ticketQueueAddress |  | String |  |
| fromMailAddress |  | String |  |
| ticketCustomerId |  | String |  |
| CallerName | ✓ | String |  |

<a name='user-general-list-group-memberships'></a>

### List Group Memberships
List group memberships for this user.

| Parameter | Required | Type | Description |
|-----------|----------|------|-------------|
| UserName | ✓ | String |  |
| GroupType |  | String | Filter by group type: Security (security permissions only), M365 (Microsoft 365 groups with mailbox), or All (default). |
| MembershipType |  | String | Filter by membership type: Assigned (manually added members), Dynamic (rule-based membership), or All (default). |
| RoleAssignable |  | String | Filter groups that can be assigned to Azure AD roles: Yes (role-assignable only) or NotSet (all groups, default). |
| TeamsEnabled |  | String | Filter groups with Microsoft Teams functionality: Yes (Teams-enabled only) or NotSet (all groups, default). |
| Source |  | String | Filter by group origin: Cloud (Azure AD only), OnPrem (synchronized from on-premises AD), or All (default). |
| WritebackEnabled |  | String | Filter groups with writeback to on-premises AD enabled: Yes (writeback enabled), No (writeback disabled), or All (default). |
| CallerName | ✓ | String | CallerName is tracked purely for auditing purposes |

[Back to the RealmJoin runbook parameter overview](#table-of-contents)

<a name='user-mail'></a>
## Mail

<a name='user-mail-add-or-remove-email-address'></a>

### Add Or Remove Email Address
Add/remove eMail address to/from mailbox.

| Parameter | Required | Type | Description |
|-----------|----------|------|-------------|
| UserName | ✓ | String |  |
| eMailAddress | ✓ | String |  |
| Remove |  | Boolean |  |
| asPrimary |  | Boolean |  |
| CallerName | ✓ | String | CallerName is tracked purely for auditing purposes |

<a name='user-mail-assign-owa-mailbox-policy'></a>

### Assign OWA Mailbox Policy
Assign a given OWA mailbox policy to a user.

| Parameter | Required | Type | Description |
|-----------|----------|------|-------------|
| UserName | ✓ | String |  |
| OwaPolicyName | ✓ | String |  |
| CallerName | ✓ | String | CallerName is tracked purely for auditing purposes |

<a name='user-mail-convert-to-shared-mailbox'></a>

### Convert To Shared Mailbox
Turn this users mailbox into a shared mailbox.

| Parameter | Required | Type | Description |
|-----------|----------|------|-------------|
| UserName | ✓ | String |  |
| delegateTo |  | String |  |
| Remove |  | Boolean |  |
| AutoMapping |  | Boolean |  |
| RemoveGroups |  | Boolean |  |
| ArchivalLicenseGroup |  | String |  |
| RegularLicenseGroup |  | String |  |
| CallerName | ✓ | String | CallerName is tracked purely for auditing purposes |

[Back to the RealmJoin runbook parameter overview](#table-of-contents)

