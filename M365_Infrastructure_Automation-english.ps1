function Disable-InactiveUsers {
    param (
        [int]$DaysInactive = 90
    )
    # Connect to Microsoft Graph with required permissions
    Connect-MgGraph -Scopes "AuditLog.Read.All", "User.Read.All"

    $thresholdDate = (Get-Date).AddDays(-$DaysInactive)
    $users = Get-MgUser -All -Filter "accountEnabled eq true" -Property Id,DisplayName,UserPrincipalName

    foreach ($user in $users) {
        # Check the user's last sign-in date
        $signins = Get-MgAuditLogSignIn -Filter "userId eq '$($user.Id)'" -Top 1
        if ($signins.Count -eq 0 -or ($signins[0].CreatedDateTime -lt $thresholdDate)) {
            Write-Output "Disabling user: $($user.UserPrincipalName)"
            Update-MgUser -UserId $user.Id -AccountEnabled:$false
        }
    }
}

function Add-UsersToGroupByDepartment {
    param (
        [string]$Department,
        [string]$GroupId
    )
    # Connect to Azure AD
    Connect-AzureAD

    # Get all users in the specified department
    $targetUsers = Get-AzureADUser -All $true | Where-Object { $_.Department -eq $Department }

    # Get current group members
    $currentMembers = Get-AzureADGroupMember -ObjectId $GroupId -All $true

    # Add missing users to the group
    foreach ($user in $targetUsers) {
        if (-not ($currentMembers.ObjectId -contains $user.ObjectId)) {
            Write-Output "➕ Adding user: $($user.UserPrincipalName)"
            Add-AzureADGroupMember -ObjectId $GroupId -RefObjectId $user.ObjectId
        }
    }

    # Remove users no longer in the department
    foreach ($member in $currentMembers) {
        $user = Get-AzureADUser -ObjectId $member.ObjectId
        if ($user.Department -ne $Department) {
            Write-Output "➖ Removing user: $($user.UserPrincipalName)"
            Remove-AzureADGroupMember -ObjectId $GroupId -MemberId $user.ObjectId
        }
    }
}

function Create-NewUserWithLicense {
    param (
        [string]$DisplayName,
        [string]$UserPrincipalName,
        [string]$Password,
        [string]$LicenseSku = "ENTERPRISEPREMIUM"
    )
    # Connect to Microsoft Graph
    Connect-MgGraph -Scopes "User.ReadWrite.All", "Directory.ReadWrite.All", "Organization.Read.All"

    # Create a new user profile
    $user = @{
        accountEnabled = $true
        displayName = $DisplayName
        mailNickname = $UserPrincipalName.Split("@")[0]
        userPrincipalName = $UserPrincipalName
        passwordProfile = @{
            forceChangePasswordNextSignIn = $true
            password = $Password
        }
    }

    $newUser = New-MgUser -BodyParameter $user

    # Assign license to the new user
    $sku = Get-MgSubscribedSku | Where-Object {$_.SkuPartNumber -eq $LicenseSku}
    Add-MgUserLicense -UserId $newUser.Id -AddLicenses @{SkuId=$sku.SkuId} -RemoveLicenses @()
}

function Export-MFAStatusReport {
    param (
        [string]$OutputPath = "MFA_Status_Report.csv"
    )
    # Connect to Microsoft Graph
    Connect-MgGraph -Scopes "UserAuthenticationMethod.Read.All"

    $users = Get-MgUser -All
    $results = foreach ($user in $users) {
        # Check if the user has MFA methods
        $methods = Get-MgUserAuthenticationMethod -UserId $user.Id
        [PSCustomObject]@{
            User = $user.UserPrincipalName
            MFA_Enabled = $methods.Count -gt 0
        }
    }

    # Export the report to CSV
    $results | Export-Csv -Path $OutputPath -NoTypeInformation
}
