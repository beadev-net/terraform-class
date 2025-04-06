resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  dns_servers         = var.dns_servers

  dynamic "subnet" {
    for_each = var.subnets

    content {
      name             = subnet.value.name
      address_prefixes = subnet.value.address_prefixes
      security_group   = subnet.value.security_group

      dynamic "delegation" {
        for_each = [for d in [subnet.value.delegation] : d if d != null]
        content {
          name = delegation.value.name
          service_delegation {
            name    = delegation.value.service_delegation.name
            actions = delegation.value.service_delegation.actions
          }
        }
      }
    }
  }

  tags = var.tags
}