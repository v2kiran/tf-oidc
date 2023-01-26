$file = 'C:\gh\tf-oidc\.github\variables\sections.env'
$file2 = 'C:\gh\tf-oidc\.github\variables\sections.env::two::three;C:\gh\tf-oidc\.github\variables\sections2.env::four;C:\gh\tf-oidc\.github\variables\sections2.env'


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





<# $file2 -split ';' -replace '::.*'

($g | Measure-Object).Count -gt 0

$h = $c1['one']

$h.GetEnumerator() | ForEach-Object {
  "$($_.key)=$($_.value)"


  $env_var_array = $file2 -split ';'
$env_var_array | ForEach-Object {
  $items = $_ -split '::'
  $file = $items | Where-Object { $_ -match '\.env' }
  $sections = $items | Where-Object { $_ -notmatch '\.env' }
  Write-Host "this is file : $file" -ForegroundColor Magenta
  Write-Host 'this is sections ' -ForegroundColor Green
  $sections
}
} #>

$file3 = "C:\gh\tf-oidc\.github\variables\sections2.env"
get-content $file3 | foreach-Object {
  if( ($_ -notmatch '^\[section:') -and ($_ -notmatch "^#") -and ($_.trim() -ne ""))
  {
    "$_"
  }
}


"[section:one] this is " -match '^\[section:'

-or ($_ -notmatch "^#")