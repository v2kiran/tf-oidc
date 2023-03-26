
$hash = $env:DataTopologies
$hash1 = $env:DataTopologies1

$json_hash = $hash1 | ConvertFrom-Json -AsHashtable
$json_hash.gettype()


$a = $hash | ConvertTo-Json -Compress

$b = $a | ConvertFrom-Json -AsHashtable
Write-Verbose 'from ps script - this is b' -Verbose
$b.gettype()

$json_hash.GetEnumerator() | ForEach-Object {
    $seq = $_.Key
    $nested_hash = $_.value

    Write-Verbose "this is the sub: $($nested_hash['sub'])" -Verbose
    Write-Verbose "this is the name: $($nested_hash['name'])" -Verbose

}