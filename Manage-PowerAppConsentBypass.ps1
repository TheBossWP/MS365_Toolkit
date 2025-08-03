<#
.SYNOPSIS
Provides helper functions to set or clear bypassing of user consent for a Power App's APIs.

.DESCRIPTION
This script exposes two functions that wrap the Set-AdminPowerAppApisToBypassConsent and
Clear-AdminPowerAppApisToBypassConsent cmdlets. Use these functions to enable or disable the
user consent bypass for an app within a given Power Platform environment.

.NOTES
Requires the Microsoft.PowerApps.Administration.PowerShell module and an authenticated
administrator session using Add-PowerAppsAccount.
#>

function Enable-PowerAppConsentBypass {
    <#
    .SYNOPSIS
    Enables bypassing of user consent for a Power App.

    .DESCRIPTION
    Calls Set-AdminPowerAppApisToBypassConsent so that the specified app can use its APIs without
    requiring individual user consent in the target environment.

    .PARAMETER EnvironmentName
    The name or GUID of the Power Platform environment where the app resides.

    .PARAMETER AppName
    The name of the Power App for which consent bypass should be enabled.

    .PARAMETER ApiVersion
    Optional API version if a specific version is required.

    .EXAMPLE
    Enable-PowerAppConsentBypass -EnvironmentName "Default-1234" -AppName "MyPowerApp"
    Enables consent bypass for the app named MyPowerApp in the Default environment.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$EnvironmentName,

        [Parameter(Mandatory=$true)]
        [string]$AppName,

        [Parameter(Mandatory=$false)]
        [string]$ApiVersion
    )

    $params = @{EnvironmentName = $EnvironmentName; AppName = $AppName}
    if ($PSBoundParameters.ContainsKey('ApiVersion')) { $params.ApiVersion = $ApiVersion }
    Set-AdminPowerAppApisToBypassConsent @params
}

function Disable-PowerAppConsentBypass {
    <#
    .SYNOPSIS
    Disables bypassing of user consent for a Power App.

    .DESCRIPTION
    Calls Clear-AdminPowerAppApisToBypassConsent so that the specified app once again requires
    user consent for its APIs in the target environment.

    .PARAMETER EnvironmentName
    The name or GUID of the Power Platform environment where the app resides.

    .PARAMETER AppName
    The name of the Power App for which consent bypass should be disabled.

    .PARAMETER ApiVersion
    Optional API version if a specific version is required.

    .EXAMPLE
    Disable-PowerAppConsentBypass -EnvironmentName "Default-1234" -AppName "MyPowerApp"
    Removes consent bypass for the app named MyPowerApp in the Default environment.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$EnvironmentName,

        [Parameter(Mandatory=$true)]
        [string]$AppName,

        [Parameter(Mandatory=$false)]
        [string]$ApiVersion
    )

    $params = @{EnvironmentName = $EnvironmentName; AppName = $AppName}
    if ($PSBoundParameters.ContainsKey('ApiVersion')) { $params.ApiVersion = $ApiVersion }
    Clear-AdminPowerAppApisToBypassConsent @params
}

# Example calls
# Enable-PowerAppConsentBypass -EnvironmentName "Default-1234" -AppName "MyPowerApp"
# Disable-PowerAppConsentBypass -EnvironmentName "Default-1234" -AppName "MyPowerApp"

