
$hash = [hashtable]$env:DataTopologies
Write-Verbose 'from ps script' -Verbose
$hash.gettype()

$hash.GetEnumerator() | ForEach-Object {
    $seq = $_.Key
    $nested_hash = $_.value

    Write-Verbose "this is the sub: $($nested_hash['sub'])" -Verbose
    Write-Verbose "this is the name: $($nested_hash['name'])" -Verbose

}