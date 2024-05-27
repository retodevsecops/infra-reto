terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.97"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.48"
    }
}

  backend "azurerm" {
    resource_group_name  = "rg_reto_devsecops"
    storage_account_name = "saretodevsecops"
    container_name       = "tfstate"
    key                  = "acr.terraform.tfstate"
  }
}