# Storage Account
resource "azurerm_storage_account" "this" {
  name                     = var.storage_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_2"

  shared_access_key_enabled     = "true"
  public_network_access_enabled = "true"


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
  storage_account_name   = azurerm_storage_account.this.name
  storage_container_name = azurerm_storage_container.this.name
  type                   = "Block"
  source_content         = "" 
}
