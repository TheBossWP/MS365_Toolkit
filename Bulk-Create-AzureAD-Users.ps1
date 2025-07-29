<#
.SYNOPSIS
Bulk create Azure AD users from a CSV file.

.EXAMPLE
CSV file format (first line should be column headers):
UserPrincipalName,DisplayName,FirstName,LastName,JobTitle,Department,Password
alice@contoso.com,Alice Smith,Alice,Smith,Sales Manager,Sales,P@ssword123!
bob@contoso.com,Bob Brown,Bob,Brown,Developer,IT,P@ssword456!
...

.DESCRIPTION
Reads user data from a CSV and creates new users in Azure Active Directory.
Requires AzureAD PowerShell module.
#>

# Load the AzureAD module
Import-Module AzureAD

# Connect to Azure AD (interactive login)
Connect-AzureAD

# Import users from CSV file
$users = Import-Csv -Path "C:\Path\To\users.csv"

foreach ($user in $users) {
    # Create a PasswordProfile object
    $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $PasswordProfile.Password = $user.Password
    $PasswordProfile.ForceChangePasswordNextLogin = $false

    try {
        # Create the new Azure AD user
        New-AzureADUser `
            -UserPrincipalName $user.UserPrincipalName `
            -DisplayName $user.DisplayName `
            -GivenName $user.FirstName `
            -Surname $user.LastName `
            -JobTitle $user.JobTitle `
            -Department $user.Department `
            -AccountEnabled $true `
            -PasswordProfile $PasswordProfile

        Write-Host "User created: $($user.UserPrincipalName)"
    }
    catch {
        Write-Host "Failed to create user: $($user.UserPrincipalName) - $($_.Exception.Message)"
    }
}

Write-Host "Bulk user creation completed."
