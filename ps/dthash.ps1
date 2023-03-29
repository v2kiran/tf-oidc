
$hash = $env:DataTopologies
$hash1 = $env:DataTopologies1
$hash2 = $env:DataTopologies2
$hash3 = $env:datatopology

$hash3

$json_hash = $hash3 | ConvertFrom-Json -AsHashtable
$json_hash.gettype()
$json_hash
$a = ConvertFrom-StringData -StringData $hash2
Write-Verbose 'from ps script - this is a' -Verbose
$a.gettype()

$a.GetEnumerator() | ForEach-Object {
    $seq = $_.Key
    $nested_hash = $_.value

    Write-Verbose "this is the sub: $($nested_hash['sub'])" -Verbose
    Write-Verbose "this is the name: $($nested_hash['name'])" -Verbose

}



<#
$DataTopologies = 'something = @{0006=@{SequenceCode="06";SubscriptionId="123"};0005=@{SequenceCode="05";SubscriptionId="456"}}'
$k,$v = $DataTopologies -split '=',2 | % {$_.Trim() }
$k

Set-Item -Path $Env:GITHUB_ENV -Value $k=$v  #>