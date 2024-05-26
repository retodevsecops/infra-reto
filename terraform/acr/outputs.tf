output "resource_group" {
  value = azurerm_container_registry.acr.resource_group_name
}

output "location" {
  value = azurerm_container_registry.acr.location
}

output "login" {
  value = azurerm_container_registry.acr.login_server
}

output "username" {
  value = azurerm_container_registry.acr.admin_username
}

output "acr_id" {
  value = azurerm_container_registry.acr.id
}