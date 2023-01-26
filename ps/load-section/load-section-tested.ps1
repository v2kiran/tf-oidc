$file = 'C:\gh\tf-oidc\.github\variables\sections.env'

Function Get-IniFile
{

  Param
  (
    [parameter(mandatory = $true)]
    [string]
    $path
  )
  $inifile = $path
  $ini = @{}

  Get-Content $inifile | ForEach-Object {
    $_.Trim()
  } | Where-Object {
    $_ -notmatch '^(#|$)'
  } | ForEach-Object {
    if ($_ -match '^\[section:.*\]$')
    {
      $section = $_ -replace '\[section:|\]'
      $ini[$section] = @{}
    }
    else
    {
      $key, $value = $_ -split '\s*=\s*', 2
      $ini[$section][$key] = $value
    }
  }

  $ini

}

$c1 = Get-IniFile -path $file
$c1['Three']['computer3']