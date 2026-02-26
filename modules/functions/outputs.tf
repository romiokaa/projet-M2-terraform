output "function_identity_principal_id" {
  value = azurerm_linux_function_app.python_func.identity[0].principal_id
}

output "function_app_id" {
  value = azurerm_linux_function_app.python_func.id
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


