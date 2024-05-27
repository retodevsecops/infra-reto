provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg_reto_devsecops"
    storage_account_name = "saretodevsecops"
    container_name       = "scretodevsecopsacr"
    key                  = "reto.terraform.tfstate"
  }
}

# Resource container registry
resource "azurerm_container_registry" "acr" {
  name                = var.ACR_NAME
  resource_group_name = var.RESOURCE_GROUP_NAME
  location            = var.LOCATION
  sku                 = "Basic"
  admin_enabled       = true
}
