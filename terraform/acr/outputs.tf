output "resource_group" {
  value = nonsensitive(azurerm_container_registry.acr.resource_group_name)
}

output "location" {
  value = nonsensitive(azurerm_container_registry.acr.location)
}

output "login" {
  value = nonsensitive(azurerm_container_registry.acr.login_server)
}

output "username" {
  value = nonsensitive(azurerm_container_registry.acr.admin_username)
}

output "acr_id" {
  value = nonsensitive(azurerm_container_registry.acr.id)
}