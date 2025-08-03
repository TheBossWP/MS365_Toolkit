# This script demonstrates how to manage the Power Apps consent dialog.
# It uses the Set-AdminPowerAppApisToBypassConsent and
# Clear-AdminPowerAppApisToBypassConsent cmdlets to control whether
# a Power App prompts for permissions.
#
# Prerequisites:
# 1. Install the required PowerShell modules (run once per machine):
#    Install-Module -Name Microsoft.PowerApps.Administration.PowerShell
#    Install-Module -Name Microsoft.PowerApps.PowerShell -AllowClobber
# 2. Authenticate to the Power Apps service with an administrator account:
#    Add-PowerAppsAccount
#    Add-AdminPowerAppsAccount
# 3. Ensure the app is already shared with the same user running this script.
# 4. Permissions required: Global Admin, Power Platform Admin, or Dynamics 365
#    Administrator, and Environment Admin for the app's environment.
#
# After the prerequisites are met, update the variables below and
# run either example to set or clear the bypass consent feature.

# Variables holding environment and app identifiers.
$environmentName = "<EnvironmentName>"   # e.g. Default-12345678-90ab-cdef-1234-567890abcdef
$appName = "<AppName>"                   # e.g. 01234567-89ab-cdef-0123-456789abcdef
$apiVersion = "2024-04-01"               # Optional API version parameter

# Example: allow the app to bypass the permissions consent dialog.
#Set-AdminPowerAppApisToBypassConsent -EnvironmentName $environmentName -AppName $appName -ApiVersion $apiVersion
#Set-AdminPowerAppApisToBypassConsent -EnvironmentName "Default-12345678-90ab-cdef-1234-567890abcdef" -AppName "01234567-89ab-cdef-0123-456789abcdef" -ApiVersion "2024-04-01"

# Example: remove the bypass consent setting from the app.
#Clear-AdminPowerAppApisToBypassConsent -EnvironmentName $environmentName -AppName $appName -ApiVersion $apiVersion
#Clear-AdminPowerAppApisToBypassConsent -EnvironmentName "Default-12345678-90ab-cdef-1234-567890abcdef" -AppName "01234567-89ab-cdef-0123-456789abcdef" -ApiVersion "2024-04-01"
