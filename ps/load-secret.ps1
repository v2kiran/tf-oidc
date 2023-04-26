
$cert_path = 'ps/certs/test.pem'

Write-Output 'cert<<EOF' | Out-File $env:GITHUB_ENV
Get-Content $cert_path -Raw  | Out-File $env:GITHUB_ENV
Write-Output 'EOF' | Out-File $env:GITHUB_ENV
