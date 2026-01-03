# Resource Group
module "resource-group" {
  source              = "../../../Modules/Resource-Group"
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = merge(var.env_tags, var.backend_tags)
}

# Event Hub 
module "event-hub" {
  source                  = "../../../Modules/Event-Hub"
  resource_group_name     = var.resource_group_name
  eventhub_name           = var.eventhub_name
  eventhub_namespace      = var.eventhub_namespace
  eventhub_auth_rule_name = var.eventhub_auth_rule_name
  location                = var.location
  tags                    = var.env_tags

  depends_on = [module.resource-group]
}

# Storage
module "storage" {
  source                 = "../../../Modules/Storage"
  resource_group_name    = var.resource_group_name
  storage_account_name   = var.storage_account_name
  storage_container_name = var.storage_container_name
  state_key              = var.state_key
  location               = var.location

  eventhub_name         = var.eventhub_name
  eventhub_namespace    = var.eventhub_namespace
  eventhub_auth_rule_id = module.event-hub.eventhub_auth_rule_id

  depends_on = [module.resource-group, module.event-hub]

  tags = merge(var.env_tags, var.backend_tags)
}

