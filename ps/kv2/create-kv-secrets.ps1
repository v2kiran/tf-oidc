$psd_values = Import-PowerShellDataFile .\vaultparms.psd1
$environments = $psd_values.keys

#region Check Azure login
$azContext = Get-AzContext
if (-not $azContext)
{
    Write-Host 'ERROR!' -ForegroundColor 'Red'
    throw "There is no active login for Azure. Please login first (eg 'Connect-AzAccount'"
}
Write-Host 'SUCCESS!' -ForegroundColor 'Green'
#endregion Check Azure login


#region Create KeyVault Secrets
$taskMessage = 'Creating KeyVault Secrets for Terraform'
Write-Verbose -Message "$taskMessage..." -Verbose

foreach ($e in $environments)
{
    $vaultName = $psd_values.$e.VaultName
    Write-Verbose "Working on Env:[$e] with VaultName:[$vaultName]" -Verbose
    foreach ($secret_item in $psd_values.$e.common.GetEnumerator())
    {

        $AzKeyVaultSecretParams = @{
            VaultName   = $vaultName
            Name        = $secret_item.Key
            SecretValue = (ConvertTo-SecureString -String $secret_item.Value -AsPlainText -Force)
            ErrorAction = 'Stop'
            Verbose     = $true
        }
        Set-AzKeyVaultSecret @AzKeyVaultSecretParams | Out-String | Write-Verbose
    }
}
#endregion Create KeyVault Secrets
