# pass variables as arguements on command line
terraform plan -var rg_name=siva-tf -var rg_location=centralindia
terraform apply -var rg_name=siva-tf -var rg_location=centralindia


# pass variable values from a var file
terraform plan -var-file="myvars.tfvars"
terraform apply -var-file="myvars.tfvars"