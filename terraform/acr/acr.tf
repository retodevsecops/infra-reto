provider "azurerm" {
  features {}
}

resource "azurerm_container_registry" "acr" {
  name                = var.ACR_NAME
  resource_group_name = var.RESOURCE_GROUP_NAME
  location            = var.LOCATION
  sku                 = "Basic"
  admin_enabled       = true

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.acr.id
    ]
  }
}
