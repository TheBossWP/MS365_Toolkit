# Microsoft 365 PowerShell Automation Toolkit

This repository contains a collection of PowerShell scripts and reusable functions to automate common Microsoft 365 administration tasks. All scripts rely on the Microsoft Graph or AzureAD modules.

---

## Script Overview

- **Bulk-Assign-License-To-Group-Users.ps1** – Assign a specific license SKU to every user inside a given Azure AD group.
- **Bulk-Create-AzureAD-Users.ps1** – Create multiple users in Azure AD from a CSV file containing their details.
- **Export-All-PowerAutomate-Flows-With-Owners.ps1** – Export all Power Automate flows across the tenant along with the flow owner into `AllFlowsAndOwners.csv`.
- **Export-PrivilegedRoleUsers.ps1** – Save a list of users holding a chosen privileged role to a CSV file.
- **Manage-PowerAppsConsentBypass.ps1** – Demonstrates managing the Power Apps consent dialog by using `Set-AdminPowerAppApisToBypassConsent` and `Clear-AdminPowerAppApisToBypassConsent` to allow or remove bypass consent for an app.
- **M365_Infrastructure_Automation-english.ps1** – Script containing reusable functions (documented below) written in English.
- **M365_Infrastructure_Automation.ps1** – Hebrew version of the same functions.

---

## Functions Overview (from `M365_Infrastructure_Automation-english.ps1`)

### `Disable-InactiveUsers`

**Description:**
Disables Microsoft 365 user accounts that have not signed in within a defined number of days.

**Parameters:**
- `DaysInactive` *(int)* – Number of days since last sign-in to consider a user inactive. Default is 90.

**Returns:**
Does not return a value. Outputs a message for each disabled user.

**Usage Example:**
```powershell
Disable-InactiveUsers -DaysInactive 60
```

---

### `Add-UsersToGroupByDepartment`

**Description:**
Adds users from a specific department to an Azure AD group and removes users who no longer belong to that department.

**Parameters:**
- `Department` *(string)* – Department name to filter users.
- `GroupId` *(string)* – Object ID of the Azure AD group.

**Returns:**
Does not return a value. Outputs added/removed users.

**Usage Example:**
```powershell
Add-UsersToGroupByDepartment -Department "HR" -GroupId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

---

### `Create-NewUserWithLicense`

**Description:**
Creates a new Microsoft 365 user account and assigns a license.

**Parameters:**
- `DisplayName` *(string)* – The full name of the user.
- `UserPrincipalName` *(string)* – The UPN (email) of the user.
- `Password` *(string)* – Initial password for the account.
- `LicenseSku` *(string, optional)* – The license SKU (e.g., `ENTERPRISEPREMIUM`). Default is `"ENTERPRISEPREMIUM"`.

**Returns:**
Does not return a value. Outputs nothing by default but creates a user and assigns a license.

**Usage Example:**
```powershell
Create-NewUserWithLicense -DisplayName "Jane Doe" -UserPrincipalName "jane.doe@contoso.com" -Password "SecurePassw0rd!"
```

---

### `Export-MFAStatusReport`

**Description:**
Generates a CSV report listing all users and whether MFA (Multi-Factor Authentication) is enabled.

**Parameters:**
- `OutputPath` *(string, optional)* – File path for the CSV output. Default is `"MFA_Status_Report.csv"`.

**Returns:**
Exports a CSV file containing `User` and `MFA_Enabled` columns.

**Usage Example:**
```powershell
Export-MFAStatusReport -OutputPath "C:\\Reports\\MFA_Report.csv"
```

---

## Requirements

- PowerShell 7+ recommended
- Modules:
  - `Microsoft.Graph` (install with `Install-Module Microsoft.Graph`)
  - `AzureAD` (install with `Install-Module AzureAD`)

## Target Audience

This toolkit is intended for IT administrators managing Microsoft 365 tenants, including automation of user lifecycle, group memberships and license assignments.
