﻿$storageaccount = $env:ADLSStorageAccount | ConvertFrom-Json

foreach ($stg in $storageaccount)
{
    Write-Verbose "the name is $($stg.storageAccountName)" -Verbose
    Write-Verbose "the ResourceGroupName is $($stg.ResourceGroupName)" -Verbose
}