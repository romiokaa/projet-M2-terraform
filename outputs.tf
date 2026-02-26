output "storage_account_name" {
  description = "Nom du compte de stockage déployé"
  value       = module.storage.storage_account_name
}

output "images_container_name" {
  value = module.storage.images_container_name
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "results_container_name" {
  description = "Nom du container de résultats OCR"
  value       = module.storage.results_container_name
}

output "storage_account_id" {
  description = "ID du Storage Account"
  value       = module.storage.storage_account_id
}

output "key_vault_uri" {
  description = "URI du Key Vault"
  value       = module.key_vault.vault_uri
}

output "key_vault_id" {
  description = "ID du Key Vault"
  value       = module.key_vault.key_vault_id
}

output "function_app_name" {
  description = "Nom de la Function App"
  value       = module.my_functions.function_app_name
}

output "function_principal_id" {
  description = "Principal ID (Managed Identity) de la Function"
  value       = module.my_functions.function_identity_principal_id
}

output "function_hostname" {
  description = "Hostname par défaut de la Function App"
  value       = module.my_functions.function_app_default_hostname
}
