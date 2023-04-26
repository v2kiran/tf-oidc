
$cert_path = "ps/certs/test.pem"
$cert_content =  gc $cert_path -Raw
"cert=$cert_content" | Out-File $env:GITHUB_ENV