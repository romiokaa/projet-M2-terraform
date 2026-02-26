# modules/functions/main.tf

# 1. Plan de service (Consommation / Serverless)
resource "azurerm_service_plan" "func_plan" {
  name                = "sp-${var.project_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "Y1" # Plan Gratuit/Consommation
}

# 2. La Function App
resource "azurerm_linux_function_app" "python_func" {
  name                = "func-${var.project_name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  service_plan_id            = azurerm_service_plan.func_plan.id

  site_config {
    application_stack {
      python_version = "3.11" 
    }
  }

  
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"       = "python"
    "BLOB_CONNECTION_STRING"         = var.blob_connection_string
    "AI_VISION_ENDPOINT"             = var.ai_vision_endpoint
    "AI_VISION_KEY"                  = var.ai_vision_key
  }

  identity {
    type = "SystemAssigned"
  }
}