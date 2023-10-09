## shortcut to comment out code =  ctrl + /
# resource "azurerm_resource_group" "rg" {
#   name = "siva-tf"
#   location = "centralindia"
# }

resource "azurerm_resource_group" "rg" {
  name = var.rg_name
  location = var.rg_location
}