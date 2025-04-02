output "id" {
  value       = azurerm_container_registry.acr.id
  description = "ACR ID"
}

output "fqdn" {
  value       = azurerm_container_registry.acr.login_server
  description = "ACR FQDN"
}