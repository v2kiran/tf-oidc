[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $first,

    [Parameter()]
    [string]
    $second
)


$first = $env:firstenv
Write-Verbose ("this is first : [{0}]" -f $first)


$first -eq 'my first env'

switch ($first)
{
    'my first env' {Write-Verbose "yup that worked";break}
    default {Write-Warning 'that didnt work mate'}
}