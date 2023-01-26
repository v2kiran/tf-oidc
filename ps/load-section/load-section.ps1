$file = "C:\Users\k2\Downloads\file.txt"


$contents = Get-Content $file | Out-String
$contents = [regex]::Split($contents, '\r\n\r\n')

$contents | ? {$_} | sort | % {
    write-host this is a section
    write-host $_
}