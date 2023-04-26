
$cert_path = 'ps/certs/test.pem'


# -join (1..15 | ForEach-Object { [char]((48..57) + (65..90) + (97..122) | Get-Random) }) | Set-Variable EOF
# "cert<<$EOF" >> $env:GITHUB_ENV
# Get-Content $cert_path -Raw >> $env:GITHUB_ENV
# "$EOF" >> $env:GITHUB_ENV


-join (1..15 | ForEach-Object { [char]((48..57) + (65..90) + (97..122) | Get-Random) }) | Set-Variable EOF
"cert<<$EOF" >> $env:GITHUB_ENV
Write-Output "::add-mask::$(Get-Content $cert_path -Raw)"  >> $env:GITHUB_ENV
"$EOF" >> $env:GITHUB_ENV


# Set-Variable -Name TheSecret -Value (Get-Random)
# Write-Output "::add-mask::$TheSecret"
# "secret-number=$TheSecret" >> $env:GITHUB_OUTPUT
# run: Write-Output "::add-mask::$env:MY_NAME"


# ps 6 and above
# "{environment_variable_name}={value}" >> $env:GITHUB_ENV

<#

on: push

jobs:
  secret-generator:
    runs-on: ubuntu-latest
    steps:
    - uses: some/secret-store@v1
      with:
        credentials: ${{ secrets.SECRET_STORE_CREDENTIALS }}
        instance: ${{ secrets.SECRET_STORE_INSTANCE }}
    - name: generate secret
      shell: pwsh
      run: |
        Set-Variable -Name Generated_Secret -Value (Get-Random)
        Write-Output "::add-mask::$Generated_Secret"
        Set-Variable -Name Secret_Handle -Value (Store-Secret "$Generated_Secret")
        "handle=$Secret_Handle" >> $env:GITHUB_OUTPUT
  secret-consumer:
    runs-on: macos-latest
    needs: secret-generator
    steps:
    - uses: some/secret-store@v1
      with:
        credentials: ${{ secrets.SECRET_STORE_CREDENTIALS }}
        instance: ${{ secrets.SECRET_STORE_INSTANCE }}
    - name: use secret
      shell: pwsh
      run: |
        Set-Variable -Name Secret_Handle -Value "${{ needs.secret-generator.outputs.handle }}"
        Set-Variable -Name Retrieved_Secret -Value (Retrieve-Secret "$Secret_Handle")
        echo "::add-mask::$Retrieved_Secret"
        echo "We retrieved our masked secret: $Retrieved_Secret"

#>