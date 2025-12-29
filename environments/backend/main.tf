terraform {
  backend "azurerm" {
    resource_group_name  = var.resource_group_name
    storage_account_name = var.storage_account_name
    container_name       = var.storage_container_name
    key                  = var.state_key
  }
}

# Resource Group
module "resource-group" {
  source              = "../../Modules/Resource-Group"
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = merge(var.env_tags, var.backend_tags)
}

# Storage
module "storage" {
  source                 = "../../Modules/Storage"
  resource_group_name    = var.resource_group_name
  storage_account_name   = var.storage_account_name
  storage_container_name = var.storage_container_name
  state_key              = var.state_key
  location               = var.location

  depends_on = [module.resource-group]

  tags = merge(var.env_tags, var.backend_tags)
}
