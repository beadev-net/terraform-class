terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.25.0"
    }
  }
  required_version = "1.11.2"

  backend "azurerm" {}
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
  sku                 = "Premium"
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
  infra_subnet_id            = module.vnet.subnets_id[0]
  containers = {
    producer = {
      name   = "producer"
      image  = "demoaula04.azurecr.io/producer:0.0.1"
      cpu    = 0.25
      memory = "0.5Gi"
    }

    consumer = {
      name   = "consumer"
      image  = "demoaula04.azurecr.io/consumer:0.0.1"
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

module "vnet" {
  source              = "./modules/network"
  name                = local.name
  location            = local.location
  resource_group_name = module.resource_group.resource_group_name
  tags                = local.tags
  address_space       = ["10.0.0.0/16"]
  subnets = [
    {
      name             = "sntcontainerapps"
      address_prefixes = ["10.0.0.0/23"],
      # delegation = {
      #   name = "subnet1delegation"
      #   service_delegation = {
      #     name    = "Microsoft.App/environments"
      #     actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      #   }
      # }
    },
    {
      name             = "sntinfra"
      address_prefixes = ["10.0.90.0/24"],
    }
  ]
}

resource "azurerm_private_endpoint" "pvt_storageaccount" {
  name                = "pvt_storageaccount"
  location            = local.location
  resource_group_name = module.resource_group.resource_group_name
  subnet_id           = module.vnet.subnets_id[1]

  private_service_connection {
    name                           = "pvt_storageaccount_connection"
    private_connection_resource_id = module.storage_account.id
    is_manual_connection           = false
    subresource_names              = ["queue"]
  }
}

resource "azurerm_private_endpoint" "pvt_acr" {
  name                = "pvt_acr"
  location            = local.location
  resource_group_name = module.resource_group.resource_group_name
  subnet_id           = module.vnet.subnets_id[1]

  private_service_connection {
    name                           = "pvt_acr_connection"
    private_connection_resource_id = module.container_registry.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }
}