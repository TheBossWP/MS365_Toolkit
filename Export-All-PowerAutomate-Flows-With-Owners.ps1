<#
.SYNOPSIS
Export all Power Automate flows in the tenant with their owners to a CSV.
.DESCRIPTION
Uses Microsoft Graph PowerShell (Connect-MgGraph). Outputs AllFlowsAndOwners.csv.
#>

# Connect to Microsoft Graph (requires admin consent for Flow.Read.All, User.Read.All)
Connect-MgGraph -Scopes "Flow.Read.All","User.Read.All"

# Get all environments
$environments = Invoke-MgGraphRequest -Method GET -Uri "https://management.azure.com/providers/Microsoft.ProcessSimple/environments?api-version=2016-11-01" 
$environments = $environments.value

$results = @()

foreach ($env in $environments) {
    $envName = $env.name
    Write-Host "Processing environment: $envName"
    
    # Get all flows in environment
    $flowsUri = "https://management.azure.com/providers/Microsoft.ProcessSimple/environments/$envName/flows?api-version=2016-11-01"
    $flows = Invoke-MgGraphRequest -Method GET -Uri $flowsUri

    if ($flows.value) {
        foreach ($flow in $flows.value) {
            $flowName = $flow.properties.displayName
            $flowId = $flow.name
            $owner = $null

            # Try get the owner display name
            if ($flow.properties.creator) {
                $owner = $flow.properties.creator.displayName
            }
            elseif ($flow.properties.owner) {
                $owner = $flow.properties.owner.displayName
            }
            else {
                $owner = "Unknown"
            }

            $results += [PSCustomObject]@{
                Environment = $envName
                FlowName    = $flowName
                FlowId      = $flowId
                Owner       = $owner
            }
        }
    }
}

$results | Export-Csv -Path .\AllFlowsAndOwners.csv -NoTypeInformation -Encoding UTF8
Write-Host "Export completed. Output file: AllFlowsAndOwners.csv"
