param($header1,$header2)


$here = @"
| First Header  | Second Header |
| ------------- | ------------- |
| Content Cell  | Content Cell  |
| Content Cell  | Content Cell  |
"@
$here

$here | out-file  $GITHUB_STEP_SUMMARY -Append