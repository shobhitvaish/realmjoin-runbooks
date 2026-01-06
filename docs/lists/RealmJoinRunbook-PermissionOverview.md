# Overview
This document provides an overview of the permissions and RBAC roles required for each runbook in the RealmJoin portal. The permissions and roles are listed to ensure that the necessary access rights are granted to the appropriate users and groups.

| Category | Subcategory | Runbook Name | Synopsis | Permissions | RBAC Roles |
|----------|-------------|--------------|----------|-------------|------------|
| Device | General | Change Grouptag | Assign a new AutoPilot GroupTag to this device. | - **Type**: Microsoft Graph<br>&emsp;- Device.Read.All<br>&emsp;- DeviceManagementServiceConfig.ReadWrite.All<br> |  |
|  |  | Check Updatable Assets | Check if a device is onboarded to Windows Update for Business. | - **Type**: Microsoft Graph<br>&emsp;- WindowsUpdates.ReadWrite.All<br> |  |
|  | Security | Enable Or Disable Device | Disable a device in AzureAD. | - **Type**: Microsoft Graph<br>&emsp;- Device.Read.All<br> | - Cloud device administrator<br> |
|  |  | Isolate Or Release Device | Isolate this device. | - **Type**: WindowsDefenderATP<br>&emsp;- Machine.Read.All<br>&emsp;- Machine.Isolate<br> |  |
| Group | General | Add Or Remove Nested Group | Add/remove a nested group to/from a group. | - **Type**: Microsoft Graph<br>&emsp;- Group.ReadWrite.All<br>&emsp;- Directory.ReadWrite.All<br> |  |
|  |  | Add Or Remove Owner | Add/remove owners to/from an Office 365 group. | - **Type**: Microsoft Graph<br>&emsp;- Group.ReadWrite.All<br>&emsp;- Directory.ReadWrite.All<br>- **Type**: Office 365 Exchange Online<br>&emsp;- Exchange.ManageAsApp<br> | - Exchange administrator<br> |
|  |  | Add Or Remove User | Add/remove users to/from a group. | - **Type**: Microsoft Graph<br>&emsp;- Group.ReadWrite.All<br>&emsp;- Directory.ReadWrite.All<br> |  |
|  | Mail | Enable Or Disable External Mail | Enable/disable external parties to send eMails to O365 groups. | - **Type**: Office 365 Exchange Online<br>&emsp;- Exchange.ManageAsApp<br> | - Exchange administrator<br> |
|  |  | Show Or Hide In Address Book | (Un)hide an O365- or static Distribution-group in Address Book. | - **Type**: Office 365 Exchange Online<br>&emsp;- Exchange.ManageAsApp<br> | - Exchange administrator<br> |
| User | General | Assign Groups By Template | Assign cloud-only groups to a user based on a predefined template. |  |  |
|  |  | Assign Or Unassign License | (Un-)Assign a license to a user via group membership. | - **Type**: Microsoft Graph<br>&emsp;- User.Read.All<br>&emsp;- GroupMember.ReadWrite.All<br>&emsp;- Group.ReadWrite.All<br> |  |
|  |  | Assign Windows365 | Assign/Provision a Windows 365 instance | - **Type**: Microsoft Graph<br>&emsp;- User.Read.All<br>&emsp;- GroupMember.ReadWrite.All<br>&emsp;- Group.ReadWrite.All<br>&emsp;- User.SendMail<br> |  |
|  |  | List Group Memberships | List group memberships for this user. | - **Type**: Microsoft Graph<br>&emsp;- User.Read.All<br>&emsp;- Group.Read.All<br> |  |
|  | Mail | Add Or Remove Email Address | Add/remove eMail address to/from mailbox. | - **Type**: Office 365 Exchange Online API<br>&emsp;- Exchange.ManageAsApp<br> | - Exchange administrator<br> |
|  |  | Assign OWA Mailbox Policy | Assign a given OWA mailbox policy to a user. |  | - Exchange administrator<br> |
|  |  | Convert To Shared Mailbox | Turn this users mailbox into a shared mailbox. | - **Type**: Office 365 Exchange Online API<br>&emsp;- Exchange.ManageAsApp<br> | - Exchange administrator<br> |
