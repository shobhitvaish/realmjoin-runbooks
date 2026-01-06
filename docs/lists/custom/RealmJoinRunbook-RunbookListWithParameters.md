# Overview
This document combines the permission requirements and RBAC roles with the exposed parameters of each runbook. It helps to understand which access levels are needed alongside the required inputs to execute the runbooks.

| Category | Subcategory | Runbook Name | Synopsis | Permissions | RBAC Roles | Parameter | Required | Type | Parameter Description |
|----------|-------------|--------------|----------|-------------|------------|-----------|----------|------|-----------------------|
| Device | General | Change Grouptag | Assign a new AutoPilot GroupTag to this device. | - **Type**: Microsoft Graph<br>&emsp;- Device.Read.All<br>&emsp;- DeviceManagementServiceConfig.ReadWrite.All<br> |  | DeviceId | ✓ | String |  |
|  |  |  |  |  |  | newGroupTag |  | String |  |
|  |  |  |  |  |  | CallerName | ✓ | String |  |
|  |  | Check Updatable Assets | Check if a device is onboarded to Windows Update for Business. | - **Type**: Microsoft Graph<br>&emsp;- WindowsUpdates.ReadWrite.All<br> |  | CallerName | ✓ | String | Caller name for auditing purposes. |
|  |  |  |  |  |  | DeviceId | ✓ | String | DeviceId of the device to check onboarding status for. |
|  | Security | Enable Or Disable Device | Disable a device in AzureAD. | - **Type**: Microsoft Graph<br>&emsp;- Device.Read.All<br> | - Cloud device administrator<br> | DeviceId | ✓ | String |  |
|  |  |  |  |  |  | Enable |  | Boolean |  |
|  |  |  |  |  |  | CallerName | ✓ | String | CallerName is tracked purely for auditing purposes |
|  |  | Isolate Or Release Device | Isolate this device. | - **Type**: WindowsDefenderATP<br>&emsp;- Machine.Read.All<br>&emsp;- Machine.Isolate<br> |  | DeviceId | ✓ | String |  |
|  |  |  |  |  |  | Release | ✓ | Boolean |  |
|  |  |  |  |  |  | IsolationType |  | String |  |
|  |  |  |  |  |  | Comment | ✓ | String |  |
|  |  |  |  |  |  | CallerName | ✓ | String | CallerName is tracked purely for auditing purposes |
| Group | General | Add Or Remove Nested Group | Add/remove a nested group to/from a group. | - **Type**: Microsoft Graph<br>&emsp;- Group.ReadWrite.All<br>&emsp;- Directory.ReadWrite.All<br> |  | GroupID | ✓ | String |  |
|  |  |  |  |  |  | NestedGroupID | ✓ | String |  |
|  |  |  |  |  |  | Remove |  | Boolean |  |
|  |  |  |  |  |  | CallerName | ✓ | String | CallerName is tracked purely for auditing purposes |
|  |  | Add Or Remove Owner | Add/remove owners to/from an Office 365 group. | - **Type**: Microsoft Graph<br>&emsp;- Group.ReadWrite.All<br>&emsp;- Directory.ReadWrite.All<br>- **Type**: Office 365 Exchange Online<br>&emsp;- Exchange.ManageAsApp<br> | - Exchange administrator<br> | GroupID | ✓ | String |  |
|  |  |  |  |  |  | UserId | ✓ | String |  |
|  |  |  |  |  |  | Remove |  | Boolean |  |
|  |  |  |  |  |  | CallerName | ✓ | String | CallerName is tracked purely for auditing purposes |
|  |  | Add Or Remove User | Add/remove users to/from a group. | - **Type**: Microsoft Graph<br>&emsp;- Group.ReadWrite.All<br>&emsp;- Directory.ReadWrite.All<br> |  | GroupID | ✓ | String |  |
|  |  |  |  |  |  | UserId | ✓ | String |  |
|  |  |  |  |  |  | Remove |  | Boolean |  |
|  |  |  |  |  |  | CallerName | ✓ | String | CallerName is tracked purely for auditing purposes |
|  | Mail | Enable Or Disable External Mail | Enable/disable external parties to send eMails to O365 groups. | - **Type**: Office 365 Exchange Online<br>&emsp;- Exchange.ManageAsApp<br> | - Exchange administrator<br> | GroupId | ✓ | String |  |
|  |  |  |  |  |  | Action |  | Int32 |  |
|  |  |  |  |  |  | CallerName | ✓ | String | CallerName is tracked purely for auditing purposes |
|  |  | Show Or Hide In Address Book | (Un)hide an O365- or static Distribution-group in Address Book. | - **Type**: Office 365 Exchange Online<br>&emsp;- Exchange.ManageAsApp<br> | - Exchange administrator<br> | GroupName | ✓ | String |  |
|  |  |  |  |  |  | Action |  | Int32 |  |
|  |  |  |  |  |  | CallerName | ✓ | String | CallerName is tracked purely for auditing purposes |
| User | General | Assign Groups By Template | Assign cloud-only groups to a user based on a predefined template. |  |  | UserId | ✓ | String |  |
|  |  |  |  |  |  | GroupsTemplate |  | String | GroupsTemplate is not used directly, but is used to populate the GroupsString parameter via RJ Portal Customization |
|  |  |  |  |  |  | GroupsString | ✓ | String |  |
|  |  |  |  |  |  | UseDisplaynames |  | Boolean | $UseDisplayname = $false: GroupsString contains Group object ids, $true: GroupsString contains Group displayNames |
|  |  |  |  |  |  | CallerName | ✓ | String | CallerName is tracked purely for auditing purposes |
|  |  | Assign Or Unassign License | (Un-)Assign a license to a user via group membership. | - **Type**: Microsoft Graph<br>&emsp;- User.Read.All<br>&emsp;- GroupMember.ReadWrite.All<br>&emsp;- Group.ReadWrite.All<br> |  | UserName | ✓ | String |  |
|  |  |  |  |  |  | GroupID_License | ✓ | String | production does not supprt "ref:LicenseGroup" yet |
|  |  |  |  |  |  | Remove |  | Boolean |  |
|  |  |  |  |  |  | CallerName | ✓ | String | CallerName is tracked purely for auditing purposes |
|  |  | Assign Windows365 | Assign/Provision a Windows 365 instance | - **Type**: Microsoft Graph<br>&emsp;- User.Read.All<br>&emsp;- GroupMember.ReadWrite.All<br>&emsp;- Group.ReadWrite.All<br>&emsp;- User.SendMail<br> |  | UserName | ✓ | String |  |
|  |  |  |  |  |  | cfgProvisioningGroupName |  | String |  |
|  |  |  |  |  |  | cfgUserSettingsGroupName |  | String |  |
|  |  |  |  |  |  | licWin365GroupName |  | String |  |
|  |  |  |  |  |  | cfgProvisioningGroupPrefix |  | String |  |
|  |  |  |  |  |  | cfgUserSettingsGroupPrefix |  | String |  |
|  |  |  |  |  |  | sendMailWhenProvisioned |  | Boolean |  |
|  |  |  |  |  |  | customizeMail |  | Boolean |  |
|  |  |  |  |  |  | customMailMessage |  | String |  |
|  |  |  |  |  |  | createTicketOutOfLicenses |  | Boolean |  |
|  |  |  |  |  |  | ticketQueueAddress |  | String |  |
|  |  |  |  |  |  | fromMailAddress |  | String |  |
|  |  |  |  |  |  | ticketCustomerId |  | String |  |
|  |  |  |  |  |  | CallerName | ✓ | String |  |
|  |  | List Group Memberships | List group memberships for this user. | - **Type**: Microsoft Graph<br>&emsp;- User.Read.All<br>&emsp;- Group.Read.All<br> |  | UserName | ✓ | String |  |
|  |  |  |  |  |  | GroupType |  | String | Filter by group type: Security (security permissions only), M365 (Microsoft 365 groups with mailbox), or All (default). |
|  |  |  |  |  |  | MembershipType |  | String | Filter by membership type: Assigned (manually added members), Dynamic (rule-based membership), or All (default). |
|  |  |  |  |  |  | RoleAssignable |  | String | Filter groups that can be assigned to Azure AD roles: Yes (role-assignable only) or NotSet (all groups, default). |
|  |  |  |  |  |  | TeamsEnabled |  | String | Filter groups with Microsoft Teams functionality: Yes (Teams-enabled only) or NotSet (all groups, default). |
|  |  |  |  |  |  | Source |  | String | Filter by group origin: Cloud (Azure AD only), OnPrem (synchronized from on-premises AD), or All (default). |
|  |  |  |  |  |  | WritebackEnabled |  | String | Filter groups with writeback to on-premises AD enabled: Yes (writeback enabled), No (writeback disabled), or All (default). |
|  |  |  |  |  |  | CallerName | ✓ | String | CallerName is tracked purely for auditing purposes |
|  | Mail | Add Or Remove Email Address | Add/remove eMail address to/from mailbox. | - **Type**: Office 365 Exchange Online API<br>&emsp;- Exchange.ManageAsApp<br> | - Exchange administrator<br> | UserName | ✓ | String |  |
|  |  |  |  |  |  | eMailAddress | ✓ | String |  |
|  |  |  |  |  |  | Remove |  | Boolean |  |
|  |  |  |  |  |  | asPrimary |  | Boolean |  |
|  |  |  |  |  |  | CallerName | ✓ | String | CallerName is tracked purely for auditing purposes |
|  |  | Assign OWA Mailbox Policy | Assign a given OWA mailbox policy to a user. |  | - Exchange administrator<br> | UserName | ✓ | String |  |
|  |  |  |  |  |  | OwaPolicyName | ✓ | String |  |
|  |  |  |  |  |  | CallerName | ✓ | String | CallerName is tracked purely for auditing purposes |
|  |  | Convert To Shared Mailbox | Turn this users mailbox into a shared mailbox. | - **Type**: Office 365 Exchange Online API<br>&emsp;- Exchange.ManageAsApp<br> | - Exchange administrator<br> | UserName | ✓ | String |  |
|  |  |  |  |  |  | delegateTo |  | String |  |
|  |  |  |  |  |  | Remove |  | Boolean |  |
|  |  |  |  |  |  | AutoMapping |  | Boolean |  |
|  |  |  |  |  |  | RemoveGroups |  | Boolean |  |
|  |  |  |  |  |  | ArchivalLicenseGroup |  | String |  |
|  |  |  |  |  |  | RegularLicenseGroup |  | String |  |
|  |  |  |  |  |  | CallerName | ✓ | String | CallerName is tracked purely for auditing purposes |
