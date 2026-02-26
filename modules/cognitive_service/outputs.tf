output "cognitive_account_name" {
  value = azurerm_cognitive_account.vision.name
}

output "endpoint" {
  value = azurerm_cognitive_account.vision.endpoint
}

output "primary_key" {
  value     = azurerm_cognitive_account.vision.primary_access_key
  sensitive = true
}