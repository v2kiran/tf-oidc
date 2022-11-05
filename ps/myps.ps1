[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $first,

    [Parameter()]
    [string]
    $second
)

write-verbose ("this is firstenv:{0}" -f ${env.firstenv})

${env.firstenv} | ConvertTo-Json
$env:firstenv | ConvertTo-Json

$first = $env:firstenv

switch($first)
{
    'my first env' {Write-Verbose "yup that worked";break}
    default {Write-Warning 'that didnt work mate'}
}