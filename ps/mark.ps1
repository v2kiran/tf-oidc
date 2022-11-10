param($header1,$header2)

$ser = gsv wl* | select Name,DisplayName,Status
$here = @"
| $header1  | $header2 |
| ------------- | ------------- |
| Content Cell  | Content Cell  |
| Content Cell  | Content Cell  |



| Name  | DisplayName | Status |
$(foreach ($s in $ser)
{
`| $s.name `| $s.DisplayName `| $s.Status `|
})
"@
$here




$here | out-file  $env:GITHUB_STEP_SUMMARY -Append