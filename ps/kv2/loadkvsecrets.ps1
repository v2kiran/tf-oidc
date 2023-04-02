$vaultName = 'PSlabSharedKV001'
#region Check Azure login
$azContext = Get-AzContext
if (-not $azContext)
{
    Write-Host 'ERROR!' -ForegroundColor 'Red'
    throw "There is no active login for Azure. Please login first (eg 'Connect-AzAccount'"
}
Write-Host 'SUCCESS!' -ForegroundColor 'Green'
#endregion Check Azure login


#region Identify Azure Key Vault
$loadMessage = 'loading Terraform environment variables just for this PowerShell session'
Write-Host "`nSTARTED: $loadMessage" -ForegroundColor 'Green'

# Get Azure objects before Key Vault lookup
$tfKeyVault = Get-AzKeyVault $vaultName
if (-not $tfKeyVault)
{
    Write-Host 'ERROR!' -ForegroundColor 'Red'
    throw "Could not find Azure Key Vault with name including search string: [$vaultName]"
}
#endregion Identify Azure Key Vault


#region Get Azure KeyVault Secrets
$azure_login_vars = @{
    'ARM-SUBSCRIPTION-ID' = 'ARM_SUBSCRIPTION_ID'
    'ARM-CLIENT-ID'       = 'ARM_CLIENT_ID'
    'ARM-CLIENT-SECRET'   = 'ARM_CLIENT_SECRET'
    'ARM-TENANT-ID'       = 'ARM_TENANT_ID'
}

$terraformEnvVars = @{}

$secretNames = (Get-AzKeyVaultSecret -VaultName $vaultName).name

# Compile Get Azure KeyVault Secrets
foreach ($secretName in $secretNames)
{
    try
    {

        # Retrieve secret
        $azKeyVaultSecretParams = @{
            Name        = $secretName
            VaultName   = $tfKeyVault.VaultName
            AsPlainText = $true
            ErrorAction = 'Stop'
        }
        $tfSecret = Get-AzKeyVaultSecret @azKeyVaultSecretParams

        if ($azure_login_vars.ContainsKey($secretName))
        {
            $secretName = $azure_login_vars[$secretName]
        }
        # Add secret to hashtable
        $terraformEnvVars.$secretName = $tfSecret
    }
    catch
    {
        Write-Error -Message "ERROR: $taskMessage." -ErrorAction 'Continue'
        throw $_
    }
}
#endregion Get Azure KeyVault Secrets


#region Load Terraform environment variables
$sessionMessage = 'Setting session environment variables for Azure / Terraform'
Write-Host "`nSTARTED: $sessionMessage" -ForegroundColor 'Green'
foreach ($terraformEnvVar in $terraformEnvVars.GetEnumerator())
{

    try
    {
        $setItemParams = @{
            Path        = "env:$($terraformEnvVar.Key)"
            Value       = $terraformEnvVar.Value
            ErrorAction = 'Stop'
        }
        Set-Item @setItemParams
    }
    catch
    {
        Write-Host 'ERROR!' -ForegroundColor 'Red'
        throw $_
    }
}

#endregion Load Terraform environment variables
