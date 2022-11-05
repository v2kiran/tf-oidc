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
$env:firstenv | ConvertTo-Json

#$first = $env:firstenv

Write-Verbose ("this is first : [{0}]" -f $first)


$first -eq 'my first env'

switch ($first)
{
    'my first env' {Write-Verbose "yup that worked";break}
    default {Write-Warning 'that didnt work mate'}
}