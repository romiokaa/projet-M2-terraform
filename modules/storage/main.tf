resource "azurerm_storage_account" "storage" {
  name                     = "${var.prefix}storage${var.environment}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  https_traffic_only_enabled    = true
  min_tls_version               = "TLS1_2"
  public_network_access_enabled = true

  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
    ip_rules       = [var.allowed_ip]
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

resource "azurerm_role_assignment" "function_read_images" {
  count                = var.function_principal_id != null ? 1 : 0
  scope                = azurerm_storage_container.images.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = var.function_principal_id
}

resource "azurerm_role_assignment" "function_write_results" {
  count                = var.function_principal_id != null ? 1 : 0
  scope                = azurerm_storage_container.results.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.function_principal_id
}