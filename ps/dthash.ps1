
$hash = $env:DataTopologies
$hash1 = $env:DataTopologies1

$json_hash = $hash1 | ConvertFrom-Json
$json_hash.gettype()

Write-Verbose 'from ps script' -Verbose
$hash.gettype()

$json_hash.GetEnumerator() | ForEach-Object {
    $seq = $_.Key
    $nested_hash = $_.value

    Write-Verbose "this is the sub: $($nested_hash['sub'])" -Verbose
    Write-Verbose "this is the name: $($nested_hash['name'])" -Verbose

}