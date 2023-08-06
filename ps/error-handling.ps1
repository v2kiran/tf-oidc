
param(

    [Parameter(Mandatory = $true)]
    [System.Object]$ConfigsPath
)

try {
    $ValuesJson = "$ConfigsPath/values.json";
    $tenantid = ''

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
}
catch {
    $err = Get-Error -Newest 1
    [PSCustomObject]@{
        Command = $err.InvocationInfo.Line.Trim()
        LineNumber = $err.InvocationInfo.ScriptLineNumber
        ErrorMessage = $err.Exception.Message
        TargetObject = $err.TargetObject
    } | Format-List
    Write-Error "failed with the above details" -ErrorAction Stop
}
