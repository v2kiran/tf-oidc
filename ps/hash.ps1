[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $first,

    [Parameter()]
    [string]
    $second
)


$myout = [PSCustomObject]@{
    NUMBER3 = 'NUMBER-3'
    NUMBER4 = 'NUMBER-4'
}

$myout

$myout | Get-Member -MemberType NoteProperty | ForEach-Object {
    "$($_.Name)=$($myout.$($_.Name))"
} | Out-File -FilePath $Env:GITHUB_ENV -Append