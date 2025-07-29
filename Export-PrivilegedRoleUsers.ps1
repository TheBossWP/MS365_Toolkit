<#
.SYNOPSIS
    Export users assigned to a specific privileged role in Microsoft Entra ID (Azure AD) using Microsoft Graph.

.DESCRIPTION
    This script connects to Microsoft Graph, retrieves the role definition based on the specified role name,
    and exports the list of assigned users to a CSV file.

.PARAMETER roleName
    The display name of the role you want to query (e.g., "Global Administrator", "User Administrator").

.OUTPUT
    A CSV file named "<RoleName>_Users.csv" containing:
    - DisplayName
    - UserPrincipalName
    - Id

.USAGE
    1. Edit the `$roleName` variable to match the role you're interested in.
    2. Run the script in a PowerShell environment with Microsoft Graph SDK installed.
    3. Authenticate when prompted.
    4. The output file will be saved in the working directory.

.EXAMPLES
    # Export all Global Administrators
    $roleName = "Global Administrator"

    # Export all Security Administrators
    $roleName = "Security Administrator"
#>


# Connect to Microsoft Graph with required scopes
Connect-MgGraph -Scopes "RoleManagement.Read.Directory", "User.Read.All"

# === List of common privileged roles ===
# You can change the role name below to any of the following:
# - Global Administrator
# - Privileged Role Administrator
# - User Administrator
# - Security Administrator
# - Compliance Administrator
# - Exchange Administrator
# - SharePoint Administrator
# - Teams Administrator
# - Billing Administrator

$roleName = "Global Administrator"  # <-- Change this as needed

# Get the role definition by display name
$roleDef = Get-MgRoleManagementDirectoryRoleDefinition -Filter "displayName eq '$roleName'"

# Get all users assigned to that role
$roleAssignments = Get-MgRoleManagementDirectoryRoleAssignment -Filter "roleDefinitionId eq '$($roleDef.Id)'"

$users = foreach ($assignment in $roleAssignments) {
    Get-MgUser -UserId $assignment.PrincipalId
}

# Export to CSV
$users | Select DisplayName, UserPrincipalName, Id | Export-Csv -Path "$($roleName.Replace(' ', '_'))_Users.csv" -NoTypeInformation