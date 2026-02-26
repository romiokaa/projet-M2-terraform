output "storage_account_name" {
  description = "Nom du compte de stockage déployé"
  value       = module.storage.storage_account_name
}

output "images_container_name" {
  value = module.storage.images_container_name
}

output "resource_group_name" {
  value = azurerm_resource_group.example.name
}

# L'URL de base pour appeler tes fonctions
output "function_app_default_hostname" {
  description = "L'URL par défaut de la Function App"
  value       = azurerm_linux_function_app.python_func.default_hostname
}

# Le nom de la ressource 
output "function_app_name" {
  description = "Le nom de la Function App"
  value       = azurerm_linux_function_app.python_func.name
}

# L'ID de l'identité managée 
output "function_identity_principal_id" {
  description = "L'ID principal de l'identité managée assignée au système"
  value       = azurerm_linux_function_app.python_func.identity[0].principal_id
}

# L'ID complet de la ressource sur Azure
output "function_app_id" {
  description = "L'ID complet de la ressource Function App"
  value       = azurerm_linux_function_app.python_func.id
}