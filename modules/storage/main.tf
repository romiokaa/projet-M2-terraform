resource "azurerm_storage_account" "storage" {
  name                     = "${var.prefix}storage${var.environment}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS" 

  https_traffic_only_enabled      = true 
  min_tls_version                 = "TLS1_2" 
  public_network_access_enabled   = true 

  network_rules {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    ip_rules                   = ["37.169.128.201"] 
  }

  tags = var.tags 
}

resource "azurerm_storage_container" "images" {
  name                  = "images" 
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private" 
}

resource "azurerm_storage_container" "results" {
  name                  = "ocr-results" 
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private" 
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate" 
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private" 
}