<#
.Synopsis
A script used to export diagnostics settings configuration for all Azure resources.

.DESCRIPTION
A script used to find and export diagnostics settings configuration for Azure resources in all Azure Subscriptions.
Finally, it will save the report as a text file for each Azure Subscription.

.Notes
Created : 2020-11-16
Updated : 2022-06-16
Version : 1.0
Author : Charbel Nemnom
Twitter : @CharbelNemnom
Blog : https://charbelnemnom.com
Disclaimer: This script is provided "AS IS" with no warranties.
#>

# Install and login with Connect-AzAccount and skip when using Azure Cloud Shell
If ($null -eq (Get-Command -Name Get-CloudDrive -ErrorAction SilentlyContinue))
{
    If ($null -eq (Get-Module Az -ListAvailable -ErrorAction SilentlyContinue))
    {
        Write-Output 'Installing Az module from default repository...'
        Install-Module -Name Az -AllowClobber
    }
    Write-Output 'Importing Az Module...'
    Import-Module -Name Az
    Write-Output 'Connecting to Azure'
    Connect-AzAccount
}

# Get all Azure Subscriptions
$azSubs = Get-AzSubscription -TenantId 'e6f7641c-0828-43ab-a963-69cae0d256a4'

# Loop through all Azure Subscriptions

    # Set array
    $azlogs = @()

    # Get all Azure resources deployed in each Subscription
    $azResources = Get-AzResource

    # Get all Azure resources which have Diagnostic settings enabled and configured
    foreach ($azResource in $azResources)
    {
        $resourceId = $azResource.ResourceId
        $azDiagSettings = Get-AzDiagnosticSetting -ResourceId $resourceId `
            -WarningAction SilentlyContinue -ErrorAction SilentlyContinue | Where-Object { $_.Id -ne $NULL }

        foreach ($azDiag in $azDiagSettings)
        {
            If ($azDiag.StorageAccountId)
            {
                [string]$storage = $azDiag.StorageAccountId
                [string]$storageAccount = $storage.Split('/')[-1]
            }
            If ($azDiag.WorkspaceId)
            {
                [string]$workspace = $azDiag.WorkspaceId
                [string]$logAnalytics = $workspace.Split('/')[-1]
            }
            If ($azDiag.EventHubAuthorizationRuleId)
            {
                [string]$eHub = $azDiag.EventHubAuthorizationRuleId
                [string]$eventHub = $eHub.Split('/')[-3]
            }
            [string]$resource = $azDiag.id
            [string]$resourceName = $resource.Split('/')[-5]
            $azlogs += @($('Diagnostic setting name: ' + $azDiag.Name), ('Azure Resource name: ' + $resourceName), `
                ('Logs: ' + $azDiag.Logs), ('Metrics: ' + $azDiag.Metrics), `
                ('Storage Account Name: ' + $storageAccount), ('Log Analytics workspace: ' + $logAnalytics), `
                ('Event Hub Namespace: ' + $eventHub))
            $azlogs += @(' ')
        }
    }
    # Save Diagnostic settings report for each Azure Subscription
    $azSubName = $azSub.Name
    $azlogs > .\$azSubName.txt



## --------------------------------------------------------------------------------------------------------
$resourceId = '/subscriptions/376f5cba-5717-4c24-af4c-bfa9fb5cd79e/resourceGroups/example-resources/providers/Microsoft.Storage/storageAccounts/examplestorageacc78'
$resourceId = '/subscriptions/376f5cba-5717-4c24-af4c-bfa9fb5cd79e/resourceGroups/example-resources/providers/Microsoft.Storage/storageAccounts/examplestorageacc78/blobServices/default'
$resourceId = '/subscriptions/376f5cba-5717-4c24-af4c-bfa9fb5cd79e/resourceGroups/example-resources/providers/Microsoft.Storage/storageAccounts/examplestorageacc78/queueServices/default'
$resourceId = '/subscriptions/376f5cba-5717-4c24-af4c-bfa9fb5cd79e/resourceGroups/example-resources/providers/Microsoft.Storage/storageAccounts/examplestorageacc78/tableServices/default'

Get-AzDiagnosticSetting -ResourceId $resourceId
