$file = "C:\Users\k2\Downloads\file2.txt"

function Get-IniContent ($filePath)
{
    $ini = @{}
    switch -regex -file $FilePath
    {
        "^\[section:(.+)\]" # Section
        {
            $section = $matches[1]
            $ini[$section] = @{}
        }
        "(.+?)\s*=(.*)" # Key
        {
            $name,$value = $matches[1..2]
            $ini[$section][$name] = $value
        }
    }
    Write-Output $ini
}

$sections = Get-IniContent -filePath $file
$sections["templates"]["computer3"]


