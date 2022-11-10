param($header1,$header2)


$here = @"
| $header1  | $header2 |
| ------------- | ------------- |
| Content Cell  | Content Cell  |
| Content Cell  | Content Cell  |
"@
$here

$here | out-file  $env:GITHUB_STEP_SUMMARY -Append