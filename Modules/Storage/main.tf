# Storage Account
resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_2"

  shared_access_key_enabled     = "false"
  public_network_access_enabled = "false"


  blob_properties {
    delete_retention_policy {
      days = 30
    }
    versioning_enabled = true
  }

  tags = var.tags
}

# Container
resource "azurerm_storage_container" "this" {
  name                  = var.storage_container_name
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}

# State Key
resource "azurerm_storage_blob" "this" {
  name                   = var.state_key
  storage_account_name   = var.storage_account_name
  storage_container_name = var.storage_container_name
  type                   = "Block"
  source_content         = ""

  depends_on = [
    azurerm_storage_account.this,
    azurerm_storage_container.this
  ]
}

# Monitor
resource "azurerm_monitor_diagnostic_setting" "storage_logs" {
  name               = "${var.storage_account_name}-logs"
  target_resource_id = azurerm_storage_account.this.id

  eventhub_name                  = var.eventhub_name
  eventhub_authorization_rule_id = var.eventhub_auth_rule_id

  enabled_log { category = "StorageRead" }
  enabled_log { category = "StorageWrite" }
  enabled_log { category = "StorageDelete" }
  
  enabled_log { category = "QueueRead" }
  enabled_log { category = "QueueWrite" }
  enabled_log { category = "QueueDelete" }
  
  enabled_metric { category = "AllMetrics" }

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}