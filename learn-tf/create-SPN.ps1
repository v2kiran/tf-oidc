#step-1
az login --tenant e6f7641c-0828-43ab-a963-69cae0d256a4

az account list
az account set --subscription="376f5cba-5717-4c24-af4c-bfa9fb5cd79e"

#step-2 - create spn
# link for creating spn using azcli - https://learn.microsoft.com/en-us/cli/azure/ad/sp?view=azure-cli-latest
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/376f5cba-5717-4c24-af4c-bfa9fb5cd79e" -n azure-tf

# SPN Client ID
$appId = "6f2fe543-6be0-4821-8936-bebeb0fcb19f"


# PowerShell
$env:ARM_CLIENT_ID = "6f2fe543-6be0-4821-8936-bebeb0fcb19f"
$env:ARM_CLIENT_SECRET = "put the password of SPN here"
$env:ARM_TENANT_ID = "e6f7641c-0828-43ab-a963-69cae0d256a4"
$env:ARM_SUBSCRIPTION_ID = "376f5cba-5717-4c24-af4c-bfa9fb5cd79e"


## terraform steps
terraform init


terraform plan
