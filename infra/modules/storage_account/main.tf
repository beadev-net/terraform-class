resource "azurerm_storage_account" "sta" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  public_network_access_enabled = var.public_network_access_enabled
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  tags                          = var.tags

  # network_rules {
  #   default_action             = "Deny"
  #   ip_rules                   = ["100.0.0.1"]
  #   virtual_network_subnet_ids = [azurerm_subnet.example.id]
  # }
}

resource "azurerm_storage_queue" "queue" {
  name                 = var.queue_name
  storage_account_name = azurerm_storage_account.sta.name
}