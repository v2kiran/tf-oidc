﻿resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_resource_group" "myrg2" {
  name     = "myrg2"
  location = var.resource_group_location
}

resource "azurerm_resource_group" "myrg3" {
  name     = "myrg3"
  location = var.resource_group_location
}