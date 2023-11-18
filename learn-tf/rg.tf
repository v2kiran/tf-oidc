##################### using hard-coded variable values

## shortcut to comment out code =  ctrl + /
# resource "azurerm_resource_group" "rg" {
#   name = "siva-tf"
#   location = "centralindia"
# }

####################### using string variables

# resource "azurerm_resource_group" "rg" {
#   name     = var.rg_name
#   location = var.rg_location
# }

# resource "azurerm_resource_group" "rg1" {
#   name     = var.rg1_name
#   location = var.rg1_location
# }

# resource "azurerm_resource_group" "rg2" {
#   name     = var.rg2_name
#   location = var.rg2_location
# }


###################### using list variable

resource "azurerm_resource_group" "rg_list" {
  for_each = var.rg_map
  name     = each.value.name
  location = each.value.location

}