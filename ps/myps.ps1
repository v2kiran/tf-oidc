[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $first,

    [Parameter()]
    [string]
    $second
)

write-verbose ("this is env:firstenv:{0}" -f $env:firstenv)

$env:firstenv
Write-Verbose "after printing firstenv"
($env:firstenv).tostring()
$env:firstenv | ConvertTo-Json

$first = $env:firstenv

Write-Verbose ("this is first : [{0}]" -f $first)
Write-Verbose ("this is first to string: [{0}]" -f $first.ToString())



switch ($first)
{
    'my first env' {Write-Verbose "yup that worked";break}
    default {Write-Warning 'that didnt work mate'}
}