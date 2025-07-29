<#
.SYNOPSIS
Bulk assign a license to all users in a specific Azure AD group.

.DESCRIPTION
Assigns a specific license SKU to all members of the given group.
Requires Microsoft Graph PowerShell module.
#>

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.ReadWrite.All","Group.Read.All"

# Set your group ID and license SKU ID
$groupId = "<YOUR_GROUP_ID>"
$licenseSkuId = "<YOUR_LICENSE_SKU_ID>" # e.g., 'c42b9cae-ea4f-4ab7-9717-81576235ccac' for M365 E3

# Get all users in the group
$users = Get-MgGroupMember -GroupId $groupId -All | Where-Object {$_.AdditionalProperties['@odata.type'] -eq '#microsoft.graph.user'}

# Assign license to each user
foreach ($user in $users) {
    $userId = $user.Id
    try {
        Set-MgUserLicense -UserId $userId -AddLicenses @{SkuId=$licenseSkuId} -RemoveLicenses @()
        Write-Host "Assigned license to user: $userId"
    } catch {
        Write-Host "Failed to assign license to user: $userId"
    }
}
Write-Host "Bulk license assignment complete."
