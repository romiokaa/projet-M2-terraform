output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}

output "storage_account_id" {
  value = azurerm_storage_account.storage.id
}

output "images_container_name" {
  value = azurerm_storage_container.images.name
}

output "results_container_name" {
  value = azurerm_storage_container.results.name
}