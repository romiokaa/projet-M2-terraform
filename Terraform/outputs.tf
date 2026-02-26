output "resource_group_name" {
  value = azurerm_resource_group.example.name
}

# L'URL de base pour appeler tes fonctions (ex: https://func-project.azurewebsites.net)
output "function_app_default_hostname" {
  description = "L'URL par défaut de la Function App"
  value       = azurerm_linux_function_app.python_func.default_hostname
}

# Le nom de la ressource (souvent utile pour les logs ou scripts Azure CLI)
output "function_app_name" {
  description = "Le nom de la Function App"
  value       = azurerm_linux_function_app.python_func.name
}

# L'ID de l'identité managée (Très important pour la sécurité !)
output "function_identity_principal_id" {
  description = "L'ID principal de l'identité managée assignée au système"
  value       = azurerm_linux_function_app.python_func.identity[0].principal_id
}

# L'ID complet de la ressource sur Azure
output "function_app_id" {
  description = "L'ID complet de la ressource Function App"
  value       = azurerm_linux_function_app.python_func.id
}