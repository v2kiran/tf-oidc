

Write-Verbose "Looking for a ADLS storage account name which contains $sequence_code and $app_env and exists in resource group where resource group name contains 'dl1'"
$ADLSStorageAccount = Get-AzStorageAccount |
    Where-Object { ($_.storageAccountName -match '1161') } | Select-Object StorageAccountName, ResourceGroupName

$json = $ADLSStorageAccount | ConvertTo-Json -Compress
#$hash = $ADLSStorageAccount | ConvertTo-Json


Write-Verbose $ADLSStorageAccount -Verbose
Write-Output $json

if ($ADLSStorageAccount)
{

        "ADLSStorageAccount=$json" | Out-File -FilePath $Env:GITHUB_ENV -Append
}
else
{
    Write-Error "Couldnt find an ADLS storage account name which contains " -ErrorAction Stop
}
