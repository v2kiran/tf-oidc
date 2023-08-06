
param(

    [Parameter(Mandatory = $true)]
    [System.Object]$ConfigsPath
)

$ValuesJson = "$ConfigsPath/values.json";
$tenantid = 'e6f7641c-0828-43ab-a963-69cae0d256a4'



$jsonObject = Get-Content -Path $ValuesJson | ConvertFrom-Json
Write-Output $jsonObject
$spnOwnerGroups = $jsonObject.AADGroups.psobject.Properties | Where-Object { $_.Value.SetSpnOwner -eq $true }

if ($spnOwnerGroups.Count -gt 0)
{
    foreach ($Group in $spnOwnerGroups)
    {
        $GroupSingle = $Group.Value
        $GroupID = $GroupSingle.ObjectId
        $GroupName = $GroupSingle.GroupName
        Write-Verbose "working on group: [$GroupName]" -Verbose

        # get the synapse instance member groups
        if ($GroupSingle.GroupMembers.psobject.Properties.name -match 'SynapseInstance')
        {
            $syn_instances = $GroupSingle.GroupMembers.psobject.Properties.name

            foreach ($member in $syn_instances)
            {
                $SynSequenceCode = $GroupSingle.GroupMembers.$member.SynapseMSI
                $SynSubscriptionId = $GroupSingle.GroupMembers.$member.SynSubscriptionId

                Select-AzSubscription -SubscriptionId $SynSubscriptionId -Tenant $tenantid
                Write-Verbose "This is the group name: [$GroupName]" -Verbose
                $files = dir
                if ($synapse_object)
                {
                    $files[0].FullName
                }#if synapse_object
            }# foreach synapse instance
        }#Synapse member groups

    }# group is present
}
