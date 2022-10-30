terraform {

  required_version = ">=1.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.7.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "stotfstate002"
    container_name       = "tfstate"
    key                  = "dev.teroidc.tfstate"
  }
}

provider "azurerm" {
  features {}
}