output "id" {
  value       = azurerm_resource_group.rg.id
  description = "The ID of the resource group."
}

output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "The resource group name."
}