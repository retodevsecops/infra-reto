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
    storage_account_name = "sa_reto_devsecops"
    container_name       = "sc_reto_devsecops_acr"
    key                  = "reto.terraform.tfstate"
  }
}

# Resource container registry
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}
