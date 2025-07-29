# Microsoft 365 PowerShell Automation Toolkit

This repository contains a set of PowerShell functions designed to automate user and group management tasks in Microsoft 365 environments. These scripts leverage Microsoft Graph and AzureAD modules.

---

## 🔧 Functions Overview

### 📌 `Disable-InactiveUsers`

**Description:**  
Disables Microsoft 365 user accounts that haven't signed in within a defined number of days.

**Parameters:**
- `DaysInactive` *(int)* – Number of days since last sign-in to consider a user inactive. Default is 90.

**Returns:**  
Does not return a value. Outputs a message for each disabled user.

**Usage Example:**
```powershell
Disable-InactiveUsers -DaysInactive 60
```

---

### 📌 `Add-UsersToGroupByDepartment`

**Description:**  
Adds users from a specific department to an Azure AD group. Also removes users who no longer belong to that department.

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

### 📌 `Create-NewUserWithLicense`

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

### 📌 `Export-MFAStatusReport`

**Description:**  
Generates a CSV report listing all users and whether MFA (Multi-Factor Authentication) is enabled.

**Parameters:**
- `OutputPath` *(string, optional)* – File path for the CSV output. Default is `"MFA_Status_Report.csv"`.

**Returns:**  
Exports a CSV file containing `User` and `MFA_Enabled` columns.

**Usage Example:**
```powershell
Export-MFAStatusReport -OutputPath "C:\Reports\MFA_Report.csv"
```

---

## 🔒 Requirements

- PowerShell 7+ recommended
- Modules:
  - `Microsoft.Graph` (install with `Install-Module Microsoft.Graph`)
  - `AzureAD` (install with `Install-Module AzureAD`)

## 🧠 Target Audience

This toolkit is intended for IT administrators managing Microsoft 365 tenants, including automation of user lifecycle, group memberships, and license assignments.