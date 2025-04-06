resource "azurerm_container_app_environment" "environment" {
  name                       = var.env_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = var.log_analytics_workspace_id
  infrastructure_subnet_id   = var.infra_subnet_id
}

resource "azurerm_container_app" "container_app" {
  for_each                     = var.containers
  name                         = each.value.name
  container_app_environment_id = azurerm_container_app_environment.environment.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    container {
      name   = each.value.name
      image  = each.value.image
      cpu    = each.value.cpu
      memory = each.value.memory
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = var.identity_ids
  }

  ingress {
    allow_insecure_connections = var.allow_insecure_connections
    external_enabled           = var.external_enabled
    target_port                = var.target_port
    transport                  = "auto"
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  registry {
    server   = var.registry_server
    identity = var.registry_identity_id
  }
}