output "subnets_id" {
  value = azurerm_virtual_network.vnet.subnet.*.id
}