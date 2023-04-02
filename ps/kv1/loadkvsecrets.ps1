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
$secretNames = @(
    'ARM_SUBSCRIPTION_ID'
    'ARM_CLIENT_ID'
    'ARM_CLIENT_SECRET'
    'ARM_TENANT_ID'
)

$azure_login_vars = @{
    'ARM_SUBSCRIPTION_ID' = $null
    'ARM_CLIENT_ID'       = $null
    'ARM_CLIENT_SECRET'   = $null
    'ARM_TENANT_ID'       = $null
}

$terraformEnvVars = @{}

# Compile Get Azure KeyVault Secrets
foreach ($secretName in $secretNames)
{
    try
    {
        # Retrieve secret
        $azKeyVaultSecretParams = @{
            Name        = $secretName -replace '_', '-'
            VaultName   = $tfKeyVault.VaultName
            AsPlainText = $true
            ErrorAction = 'Stop'
        }
        $tfSecret = Get-AzKeyVaultSecret @azKeyVaultSecretParams

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

$terraformEnvVars
#region Load Terraform environment variables
$sessionMessage = 'Setting session environment variables for Azure / Terraform'
Write-Host "`nSTARTED: $sessionMessage" -ForegroundColor 'Green'
foreach ($terraformEnvVar in $terraformEnvVars.GetEnumerator())
{
    $terraformEnvVar.Value.value
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
