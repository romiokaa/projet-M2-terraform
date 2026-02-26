# modules/functions/main.tf

# Plan de service 
resource "azurerm_service_plan" "func_plan" {
  name                = "sp-${var.project_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "Y1" # Plan Gratuit/Consommation
}

# La Function App
resource "azurerm_linux_function_app" "python_func" {
  name                = "func-${var.project_name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  storage_account_name       = var.storage_account_name
  service_plan_id            = azurerm_service_plan.func_plan.id

  site_config {
    application_stack {
      python_version = "3.11" 
    }
  }

  
app_settings = {
  "FUNCTIONS_WORKER_RUNTIME" = "python"
  VISION_KEY = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/VISION-KEY/)"
  VISION_ENDPOINT = var.ai_vision_endpoint
}

  identity {
    type = "SystemAssigned"
  }
}