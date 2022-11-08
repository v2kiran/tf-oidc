param(
  [Switch]$Raw
)
$Jobs = @()

@('ubuntu-latest', 'windows-latest') | ForEach-Object {
  $Jobs += @{
    job_name = "Run $_ jobs"
    os = $_
    command = "$_ command"
  }
}

if ($Raw) {
  Write-Host ($Jobs | ConvertTo-JSON)
} else {
  # Output the result for consumption by GitHub Actions
  Write-Host "::set-output name=matrix::$($Jobs | ConvertTo-JSON -Compress))"
}