terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.25.0"
    }
  }
  required_version = "1.11.2"
}

provider "azurerm" {
  features {}
  subscription_id = "657f10ed-40de-4452-a1b0-3031c9b7b318"
}

locals {
  name     = "demoaula04"
  location = "eastus"
  tags = {
    class = "04"
  }
}

module "resource_group" {
  source   = "./modules/resource_group"
  name     = local.name
  location = local.location
  tags     = local.tags
}

module "container_registry" {
  source              = "./modules/container_registry"
  name                = local.name
  location            = local.location
  resource_group_name = module.resource_group.resource_group_name
  tags                = local.tags
}

module "identity" {
  source              = "./modules/identity"
  name                = local.name
  location            = local.location
  resource_group_name = module.resource_group.resource_group_name
  tags                = local.tags

  role_assignments = {
    acr = {
      scope                = module.container_registry.id
      role_definition_name = "AcrPull"
    }
  }
}

module "log_analytics_workspace" {
  source              = "./modules/log_analytics"
  name                = local.name
  location            = local.location
  resource_group_name = module.resource_group.resource_group_name
}

module "containers_app" {
  source                     = "./modules/container_apps"
  location                   = local.location
  env_name                   = "${local.name}env"
  identity_ids               = [module.identity.id]
  registry_server            = module.container_registry.fqdn
  log_analytics_workspace_id = module.log_analytics_workspace.id
  registry_identity_id       = module.identity.id
  resource_group_name        = module.resource_group.resource_group_name

  containers = {
    producer = {
      name   = "producer"
      image  = "mcr.microsoft.com/k8se/quickstart:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }

    consumer = {
      name   = "consumer"
      image  = "mcr.microsoft.com/k8se/quickstart:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
}

module "storage_account" {
  source                        = "./modules/storage_account"
  name                          = local.name
  location                      = local.location
  resource_group_name           = module.resource_group.resource_group_name
  public_network_access_enabled = true
  queue_name                    = "myfirstqueue"
  tags                          = local.tags
}