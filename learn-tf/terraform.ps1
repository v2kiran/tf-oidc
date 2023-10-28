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