# login to azure by passign envrionemtn variables for azure spn
# PowerShell
$env:ARM_CLIENT_ID = "6f2fe543-6be0-4821-8936-bebeb0fcb19f"
$env:ARM_CLIENT_SECRET = "put the password of SPN here"
$env:ARM_TENANT_ID = "e6f7641c-0828-43ab-a963-69cae0d256a4"
$env:ARM_SUBSCRIPTION_ID = "376f5cba-5717-4c24-af4c-bfa9fb5cd79e"


# pass variables as arguements on command line - 1 resource group
terraform plan -var rg_name=siva-tf -var rg_location=centralindia
terraform apply -var rg_name=siva-tf -var rg_location=centralindia


# pass variables as arguements on command line - 3 resource group
terraform plan -var rg_name=siva-tf -var rg_location=centralindia -var rg1_name=siva-tf-1 -var rg1_location=southindia -var rg2_name=siva-tf-2 -var rg2_location=westindia
terraform apply -var rg_name=siva-tf -var rg_location=centralindia -var rg1_name=siva-tf-1 -var rg1_location=southindia -var rg2_name=siva-tf-2 -var rg2_location=westindia


# use plan output
terraform plan -var rg_name=siva-tf -var rg_location=centralindia -var rg1_name=siva-tf-1 -var rg1_location=southindia -var rg2_name=siva-tf-3 -var rg2_location=westindia -out output.tfplan
terraform apply .\output.tfplan


terraform plan -var-file="myvars.tfvars" -var rg2_name=siva-tf-2 -var rg2_location=westindia  -out output.tfplan
terraform apply .\output.tfplan


# pass variable values from a var file
terraform plan -var-file="myvars.tfvars"
terraform apply -var-file="myvars.tfvars"


# pass variable values from auto tfvars
terraform plan -out output.tfplan
terraform apply  .\output.tfplan