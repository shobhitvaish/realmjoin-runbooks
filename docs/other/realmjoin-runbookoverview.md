<a name='runbook-overview'></a>
# RealmJoin runbook overview
This document provides a comprehensive overview of all runbooks currently available in the RealmJoin portal. Each runbook is listed along with a brief description or synopsis to give a clear understanding of its purpose and functionality.

To ensure easy navigation, the runbooks are categorized into different sections based on their area of application. The following categories are currently available:
- device
- group
- org
- user

Each category contains multiple runbooks that are further divided into subcategories based on their functionality. The runbooks are listed in alphabetical order within each subcategory.

# Runbooks - Table of contents

- [Device](#device)
  - [General](#device-general)
      - [Change Grouptag](#change-grouptag)
      - [Check Updatable Assets](#check-updatable-assets)
  - [Security](#device-security)
      - [Enable Or Disable Device](#enable-or-disable-device)
      - [Isolate Or Release Device](#isolate-or-release-device)
- [Group](#group)
  - [General](#group-general)
      - [Add Or Remove Nested Group](#add-or-remove-nested-group)
      - [Add Or Remove Owner](#add-or-remove-owner)
      - [Add Or Remove User](#add-or-remove-user)
  - [Mail](#group-mail)
      - [Enable Or Disable External Mail](#enable-or-disable-external-mail)
      - [Show Or Hide In Address Book](#show-or-hide-in-address-book)
- [User](#user)
  - [General](#user-general)
      - [Assign Groups By Template](#assign-groups-by-template)
      - [Assign Or Unassign License](#assign-or-unassign-license)
      - [Assign Windows365](#assign-windows365)
      - [List Group Memberships](#list-group-memberships)
  - [Mail](#user-mail)
      - [Add Or Remove Email Address](#add-or-remove-email-address)
      - [Assign Owa Mailbox Policy](#assign-owa-mailbox-policy)
      - [Convert To Shared Mailbox](#convert-to-shared-mailbox)

<a name='device'></a>

# Device
<a name='device-general'></a>

## General
<a name='device-general-change-grouptag'></a>

### Change Grouptag
#### Assign a new Auto-pilot GroupTag to this device.

#### Description
Assign a new AutoPilot GroupTag to this device.

#### Where to find
Device \ General \ Change Grouptag


[Back to Table of Content](#table-of-contents)

 
 

<a name='device-general-check-updatable-assets'></a>

### Check Updatable Assets
#### Check if a device is onboarded to Windows Update for Business.

#### Description
This script checks if single device is onboarded to Windows Update for Business.

#### Where to find
Device \ General \ Check Updatable Assets


[Back to Table of Content](#table-of-contents)

 
 

<a name='device'></a>

# Device
<a name='device-security'></a>

## Security
<a name='device-security-enable-or-disable-device'></a>

### Enable Or Disable Device
#### Disable a device in AzureAD.

#### Description
Disable a device in AzureAD.

#### Where to find
Device \ Security \ Enable Or Disable Device


[Back to Table of Content](#table-of-contents)

 
 

<a name='device-security-isolate-or-release-device'></a>

### Isolate Or Release Device
#### Isolate this device.

#### Description
Isolate this device using Defender for Endpoint.

#### Where to find
Device \ Security \ Isolate Or Release Device


[Back to Table of Content](#table-of-contents)

 
 

<a name='group'></a>

# Group
<a name='group-general'></a>

## General
<a name='group-general-add-or-remove-nested-group'></a>

### Add Or Remove Nested Group
#### Add/remove a nested group to/from a group.

#### Description
Add/remove a nested group to/from an AzureAD or Exchange Online group.

#### Where to find
Group \ General \ Add Or Remove Nested Group


[Back to Table of Content](#table-of-contents)

 
 

<a name='group-general-add-or-remove-owner'></a>

### Add Or Remove Owner
#### Add/remove owners to/from an Office 365 group.

#### Description
Add/remove owners to/from an Office 365 group.

#### Where to find
Group \ General \ Add Or Remove Owner


[Back to Table of Content](#table-of-contents)

 
 

<a name='group-general-add-or-remove-user'></a>

### Add Or Remove User
#### Add/remove users to/from a group.

#### Description
Add/remove users to/from an AzureAD or Exchange Online group.

#### Where to find
Group \ General \ Add Or Remove User


[Back to Table of Content](#table-of-contents)

 
 

<a name='group'></a>

# Group
<a name='group-mail'></a>

## Mail
<a name='group-mail-enable-or-disable-external-mail'></a>

### Enable Or Disable External Mail
#### Enable/disable external parties to send eMails to O365 groups.

#### Description
Enable/disable external parties to send eMails to O365 groups.

#### Where to find
Group \ Mail \ Enable Or Disable External Mail


[Back to Table of Content](#table-of-contents)

 
 

<a name='group-mail-show-or-hide-in-address-book'></a>

### Show Or Hide In Address Book
#### (Un)hide an O365- or static Distribution-group in Address Book.

#### Description
(Un)hide an O365- or static Distribution-group in Address Book. Can also show the current state.

#### Where to find
Group \ Mail \ Show Or Hide In Address Book


[Back to Table of Content](#table-of-contents)

 
 

<a name='user'></a>

# User
<a name='user-general'></a>

## General
<a name='user-general-assign-groups-by-template'></a>

### Assign Groups By Template
#### Assign cloud-only groups to a user based on a predefined template.

#### Description
Assign cloud-only groups to a user based on a predefined template.

#### Where to find
User \ General \ Assign Groups By Template


[Back to Table of Content](#table-of-contents)

 
 

<a name='user-general-assign-or-unassign-license'></a>

### Assign Or Unassign License
#### (Un-)Assign a license to a user via group membership.

#### Description
(Un-)Assign a license to a user via group membership.

#### Where to find
User \ General \ Assign Or Unassign License


[Back to Table of Content](#table-of-contents)

 
 

<a name='user-general-assign-windows365'></a>

### Assign Windows365
#### Assign/Provision a Windows 365 instance

#### Description
Assign/Provision a Windows 365 instance for this user.

#### Where to find
User \ General \ Assign Windows365


[Back to Table of Content](#table-of-contents)

 
 

<a name='user-general-list-group-memberships'></a>

### List Group Memberships
#### List group memberships for this user.

#### Description
List group memberships for this user with filtering options for group type, membership type, role assignable status, Teams enabled status, and source.
The output is in CSV format with all group details including DisplayName, ID, Type, MembershipType, RoleAssignable, TeamsEnabled, and Source.

#### Where to find
User \ General \ List Group Memberships


[Back to Table of Content](#table-of-contents)

 
 

<a name='user'></a>

# User
<a name='user-mail'></a>

## Mail
<a name='user-mail-add-or-remove-email-address'></a>

### Add Or Remove Email Address
#### Add/remove eMail address to/from mailbox.

#### Description
Add/remove eMail address to/from mailbox, update primary eMail address.

#### Where to find
User \ Mail \ Add Or Remove Email Address


[Back to Table of Content](#table-of-contents)

 
 

<a name='user-mail-assign-owa-mailbox-policy'></a>

### Assign Owa Mailbox Policy
#### Assign a given OWA mailbox policy to a user.

#### Description
Assign a given OWA mailbox policy to a user. E.g. to allow MS Bookings.

#### Where to find
User \ Mail \ Assign Owa Mailbox Policy


[Back to Table of Content](#table-of-contents)

 
 

<a name='user-mail-convert-to-shared-mailbox'></a>

### Convert To Shared Mailbox
#### Turn this users mailbox into a shared mailbox.

#### Description
Turn this users mailbox into a shared mailbox.

#### Where to find
User \ Mail \ Convert To Shared Mailbox


[Back to Table of Content](#table-of-contents)

 
 

