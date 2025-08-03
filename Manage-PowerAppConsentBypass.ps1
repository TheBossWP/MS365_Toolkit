<#
.SYNOPSIS
Provides helper functions to toggle bypassing user consent for specific Power Apps APIs.

.DESCRIPTION
This script exposes two functions that wrap the Set-AdminPowerAppApisToBypassConsent cmdlet.
Use these functions to enable or disable the bypass of user consent prompts for a connector
within a given Power Platform environment.

.NOTES
Requires the Microsoft.PowerApps.Administration.PowerShell module and an authenticated
administrator session using Add-PowerAppsAccount.
#>

function Enable-PowerAppConsentBypass {
    <#
    .SYNOPSIS
    Enables bypassing of user consent for a specific API (connector).

    .DESCRIPTION
    Calls Set-AdminPowerAppApisToBypassConsent with BypassConsent set to $true. This allows
    the specified connector to be used without individual user consent in the target environment.

    .PARAMETER EnvironmentName
    The name or GUID of the Power Platform environment where the policy will be applied.

    .PARAMETER ApiName
    The name of the API/connector to allow without consent prompts.

    .EXAMPLE
    Enable-PowerAppConsentBypass -EnvironmentName "Default-1234" -ApiName "shared_sharepointonline"
    Enables bypass consent for the SharePoint Online connector in the Default environment.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$EnvironmentName,

        [Parameter(Mandatory=$true)]
        [string]$ApiName
    )

    Set-AdminPowerAppApisToBypassConsent -EnvironmentName $EnvironmentName -ApiName $ApiName -BypassConsent $true
}

function Disable-PowerAppConsentBypass {
    <#
    .SYNOPSIS
    Disables bypassing of user consent for a specific API (connector).

    .DESCRIPTION
    Calls Set-AdminPowerAppApisToBypassConsent with BypassConsent set to $false. This requires
    users to grant consent before using the specified connector in the target environment.

    .PARAMETER EnvironmentName
    The name or GUID of the Power Platform environment where the policy will be applied.

    .PARAMETER ApiName
    The name of the API/connector that should require user consent.

    .EXAMPLE
    Disable-PowerAppConsentBypass -EnvironmentName "Default-1234" -ApiName "shared_sharepointonline"
    Disables bypass consent for the SharePoint Online connector in the Default environment.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$EnvironmentName,

        [Parameter(Mandatory=$true)]
        [string]$ApiName
    )

    Set-AdminPowerAppApisToBypassConsent -EnvironmentName $EnvironmentName -ApiName $ApiName -BypassConsent $false
}

# Example calls
# Enable-PowerAppConsentBypass -EnvironmentName "Default-1234" -ApiName "shared_sharepointonline"
# Disable-PowerAppConsentBypass -EnvironmentName "Default-1234" -ApiName "shared_sharepointonline"

