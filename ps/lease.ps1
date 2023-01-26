


$storage = "stotfstate002"
$rg = 'tfstate'
$sto = Get-AzStorageAccount -ResourceGroupName $rg -Name $storage

$blob = Get-AzStorageBlob -Container tfstate -Blob terraform1.tfstate -Context $sto.Context

$leaseStatus = $blob.ICloudBlob.Properties.LeaseStatus
If($leaseStatus -eq "Locked")
{
        $null = $blob.ICloudBlob.BreakLease()
        Write-Verbose "['$($blob.name)']: Successfully broken lease on blob." -Verbose
}
Else
{
    #$blob.ICloudBlob.AcquireLease($null, $null, $null, $null, $null)
    Write-Verbose "['$($blob.name)']: No active lease found" -Verbose
}
