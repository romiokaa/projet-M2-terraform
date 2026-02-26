output "function_identity_principal_id" {
  value = azurerm_linux_function_app.python_func.identity[0].principal_id
}

output "function_app_id" {
  value = azurerm_linux_function_app.python_func.id
}

output "default_hostname" {
  value = azurerm_linux_function_app.python_func.default_hostname
}