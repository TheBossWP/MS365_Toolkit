
function Disable-InactiveUsers {
    param (
        [int]$DaysInactive = 90
    )
    # התחברות ל-Microsoft Graph עם ההרשאות המתאימות
    Connect-MgGraph -Scopes "AuditLog.Read.All", "User.Read.All"

    $thresholdDate = (Get-Date).AddDays(-$DaysInactive)
    $users = Get-MgUser -All -Filter "accountEnabled eq true" -Property Id,DisplayName,UserPrincipalName

    foreach ($user in $users) {
        # בדיקת תאריך הכניסה האחרון של המשתמש
        $signins = Get-MgAuditLogSignIn -Filter "userId eq '$($user.Id)'" -Top 1
        if ($signins.Count -eq 0 -or ($signins[0].CreatedDateTime -lt $thresholdDate)) {
            Write-Output "השבתת המשתמש: $($user.UserPrincipalName)"
            Update-MgUser -UserId $user.Id -AccountEnabled:$false
        }
    }
}

function Add-UsersToGroupByDepartment {
    param (
        [string]$Department,
        [string]$GroupId
    )
    # התחברות ל-Azure AD
    Connect-AzureAD

    # שליפת כל המשתמשים עם מחלקה מתאימה
    $targetUsers = Get-AzureADUser -All $true | Where-Object { $_.Department -eq $Department }

    # שליפת כל חברי הקבוצה הנוכחיים
    $currentMembers = Get-AzureADGroupMember -ObjectId $GroupId -All $true

    # הוספת משתמשים חסרים לקבוצה
    foreach ($user in $targetUsers) {
        if (-not ($currentMembers.ObjectId -contains $user.ObjectId)) {
            Write-Output "➕ הוספת המשתמש: $($user.UserPrincipalName)"
            Add-AzureADGroupMember -ObjectId $GroupId -RefObjectId $user.ObjectId
        }
    }

    # הסרת משתמשים שאינם שייכים למחלקה יותר
    foreach ($member in $currentMembers) {
        $user = Get-AzureADUser -ObjectId $member.ObjectId
        if ($user.Department -ne $Department) {
            Write-Output "➖ הסרת המשתמש: $($user.UserPrincipalName)"
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
    # התחברות ל-Microsoft Graph
    Connect-MgGraph -Scopes "User.ReadWrite.All", "Directory.ReadWrite.All", "Organization.Read.All"

    # יצירת פרופיל משתמש חדש
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

    # הקצאת רישיון למשתמש החדש
    $sku = Get-MgSubscribedSku | Where-Object {$_.SkuPartNumber -eq $LicenseSku}
    Add-MgUserLicense -UserId $newUser.Id -AddLicenses @{SkuId=$sku.SkuId} -RemoveLicenses @()
}

function Export-MFAStatusReport {
    param (
        [string]$OutputPath = "MFA_Status_Report.csv"
    )
    # התחברות ל-Microsoft Graph
    Connect-MgGraph -Scopes "UserAuthenticationMethod.Read.All"

    $users = Get-MgUser -All
    $results = foreach ($user in $users) {
        # בדיקה אם יש למשתמש שיטות אימות (MFA)
        $methods = Get-MgUserAuthenticationMethod -UserId $user.Id
        [PSCustomObject]@{
            User = $user.UserPrincipalName
            MFA_Enabled = $methods.Count -gt 0
        }
    }

    # ייצוא הדו"ח לקובץ CSV
    $results | Export-Csv -Path $OutputPath -NoTypeInformation
}
