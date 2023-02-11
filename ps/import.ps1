Write-Host "${{inputs.Resources}}"
Write-Host "${{ env.backendAzureRmResourceGroupName}}"
Write-Host "${{ env.backendAzureRmStorageAccountName }}"
Write-Host "${{ env.backendAzureRmContainerName }}"

#$resources = "${{inputs.Resources}}"
$resourceGroups = $resources.Split('::')

#terraform init -backend-config="resource_group_name=${{ env.backendAzureRmResourceGroupName}}" -backend-config="storage_account_name=${{ env.backendAzureRmStorageAccountName }}" -backend-config="container_name=${{ env.backendAzureRmContainerName }}" -backend-config="key=${{ env.stateFile }}"
Write-Error 'something wrong' -ErrorAction stop
foreach ($groups in $resourceGroups)
{
    $split = $groups.Split(';');


    $stateResponse = $(terraform state show '$split[0]')
    Write-Host $stateResponse
    if ($stateResponse -eq $null)
    {
        if ($inputs.ActivityType == 'replace')
        } {
        terraform apply -replace="$split[0]"
    }
    elseif ($inputs.ActivityType == 'import'}
    }) {
    terraform import $split[0] $split[1]
}
else {
    terraform state rm $split[0]
}
}
}